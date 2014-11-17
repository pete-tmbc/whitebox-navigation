#!/usr/bin/env perl
#
# Copyright Petri Iivonen (petri.iivonen@tmbc.gov.uk) and
# Tonbridge and Malling Borough Council (http://www.tmbc.gov.uk/)
#
# This file is part of Whitebox Navigation.
#
#    Whitebox Navigation is free software: you can redistribute it
#    and/or modify it under the terms of the GNU General Public License
#    as published by the Free Software Foundation, either version 2 of
#    the License, or (at your option) any later version.
#
#    Whitebox Navigation is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Whitebox Navigation.
#    If not, see <http://www.gnu.org/licenses/>
#
# Read TMBC "White Box" XML file, update the entry ID numbers, output
# Apache configuration file for redirects and re-write updated XML
# file.
#
use strict;
use warnings;

use Getopt::Long;
use File::Copy;
use Pod::Usage;
use XML::LibXML;
use Google::Data::JSON;

my ($input_file, $tmp_file, $output_file, $xsd_file, $json_file);
my $help        = 0;
my $debug       = 0;

my ($sourcefile, $destinationfile);

my @xml_content;

my $i           = 1;
my $redir_cond  = '';
my $redir_url   = '';
my $addqmark    = '';

# Set the options to use
GetOptions (
    "help|?"        => \$help,
    "debug"         => \$debug,
    "input=s"       => \$input_file,
    "output=s"      => \$output_file,
    "xsd_file=s"    => \$xsd_file,
    "json_file=s"   => \$json_file,
);

# check options and die if no input or output is given
die pod2usage(2) if $help;
die pod2usage(
    -msg            => "Missing XML input file",
    -exitval        => 2
) unless $input_file;
die pod2usage(
    -msg            => "Missing Apache config output file",
    -exitval        => 2
) unless $output_file;
die pod2usage(
    -msg            => "Missing XSD schema file",
    -exitval        => 2
) unless $xsd_file;
die pod2usage(
    -msg            => "Missing JSON output file",
    -exitval        => 2
) unless $json_file;

# assign values from the options
$input_file         = $input_file;
$tmp_file           = $input_file . "~";
$output_file        = $output_file;
$xsd_file           = $xsd_file;
$json_file          = $json_file;

$input_file         = $input_file;
$output_file        = $output_file;
$xsd_file           = $xsd_file;
$json_file          = $json_file;

$sourcefile         = $tmp_file;
$destinationfile    = $input_file;

# open the files for reading & writing
if($debug) {
    print "Opening $input_file\n";
};
open(my $xml_file, "<", "$input_file")
    or die "Could not open file '$input_file' $!\n";

if($debug) {
    print "Opening $tmp_file\n";
};
open(my $temp_file, ">", "$tmp_file")
    or die "Could not open '$tmp_file' $!\n";

if($debug) {
    print "Opening $output_file\n";
};
open(my $apache_config_file, ">", "$output_file")
    or die "Could not open '$output_file' $!\n";

if($debug) {
    print "Beginning processing...";
};

# Generate Apache config file and temporary, updated XML file
while(my $line = <$xml_file>) {
    if($debug) {
        print "Checking for ID...\n";
    };
    if($line =~ /(.*)(id(\s|)=(\s|)"[0-9]+")(.*)/) {
        if($debug) {
            print "found: $line\n";
        };
        $line =~ s/id(\s|)=(\s|)"([0-9])+"/id = "$i"/g;

        if($debug) {
            print "re-numbered: $line\nwriting to Apache config: RewriteCond %{QUERY_STRING} (?:^|&)id=$i\$ [NC]\n";
        };
        print $apache_config_file 'RewriteCond %{QUERY_STRING} (?:^|&)id=' . $i . '$ [NC]' , "\n";
        $i++;
        if($debug) {
            print "finished ID sequencing\n";
        };
    };

    if($debug) {
        print "checking for URL...\n";
    };
    if($line =~ /<url>(.*)<\/url>/) {
        if($debug) {
            print "found: $line\n", 'writing to Apache config: RewriteRule ^(.*)$ ' . $1 . "[NE,L,R]";
        };
        
        my $url = $1;
        if($url =~ /\?$/) {
            print $apache_config_file 'RewriteRule ^(.*)$ ' . $url . ' [NE,L,R]', "\n\n";
            print $temp_file $line;
        }
        else {
            print "[$url] is missing the '?' at the end. Do you want to add one? [no]/yes: ";
            chomp($addqmark = <STDIN>);
            if($addqmark eq 'yes') { # no point in checking 'no' value in this instance
                $url = $url . "?";
            }
            print $apache_config_file 'RewriteRule ^(.*)$ ' . $url . ' [NE,L,R]', "\n\n";
            print $temp_file "<url>$url</url>\n";
        };
    }
    else {
        print $temp_file $line;
     };
         if($debug) {
             print "finished writing Apache config.\n";
         };
}

# clean up
close($apache_config_file);
if($debug) {
    print "closed \$apache_config_file\n";
};

close($temp_file);
if($debug) {
    print "closed \$temp_file\n";
};

close($input_file);
if($debug) {
    print "closed \$input_file\n";
}

# Validate the regenerated (temporary) XML file
if($debug) {
    print "validating generated XML: $sourcefile\n";
};
my $schema = XML::LibXML::Schema->new(location =>$xsd_file);
my $parser = XML::LibXML->new;  
my $doc = $parser->parse_file($sourcefile); 
eval { $schema->validate( $doc ) };  
if(my $ex = $@) {
    die "Validation failed: $ex\n";
}     
else {
    if($debug) {
        print "XML validated\nmoving $sourcefile to $destinationfile\n";
    };
    # replace the original input XML file with the temporary one
    move($sourcefile,$destinationfile) or die "Move failed: $1\n";
}

## Convert the XML document into a JSON
if($debug) {
    print "starting JSON conversion...\nopening $input_file\n";
};
open($xml_file, "<", "$input_file")
    or die "Could not open file '$input_file' $!\n";

if($debug) {
    print "opening $json_file\n";
};
open(my $json_output, ">", "$json_file")
    or die "Could not open file '$json_file' $!\n";

my $gdata = Google::Data::JSON->new(file => $input_file);

if($debug) {
    print "starting JSON conversion...\n";
};
my $json  = $gdata->as_json
    or die "XML to JSON conversion failed: $gdata->errstr\n";

if($debug) {
    print "converting JSON to typeahead friendly format...\n";
}
# Clean up the JSON to Oxygen, Typeahead & Bloodhound friendly format:
$json =~ s/\{"\$t":((\s|)"\w+")\}/$1/g; # tokens to array
$json =~ s/\{"\$t"(\s|):(\s|)("([a-zA-Z'-? &])+")\}/$3/g; # the rest
# turn single token entries to arrays:
# "tokens": "find" + comma or not
$json =~ s/("tokens"(\s|):(\s|))"([a-zA-Z'-? &]+)"(,|)/$1\["$4"\]$5/g;
$json =~ s/xmlns\$xsi/xmlns:xsi/g;
$json =~ s/xsi\$noNamespaceSchemaLocation/xsi:noNamespaceSchemaLocation/g;
$json =~ s/"xsi:noNamespaceSchemaLocation":"([a-zA-Z'-? ])+"/"xsi:noNamespaceSchemaLocation":"$xsd_file"/;
print $json_output $json;

if($debug) {
    print "wrote JSON file $json_file\nclosing $json_file\n";
}
close $json_file;

if($debug) {
    print "closing $input_file\n";
}
close($input_file);

print <<EOF;


************************** Done! **************************


Your updated XML file is: $input_file
Your Apache config file is: $output_file
Your JSON file is: $json_file

Dont forget to:
  * update your JSON file on the server
  * update your Apache config file on the server
  * reload Apache

EOF

__END__

=head1 NAME
Generate Apache redirect configration from XML

=head1 SYNOPSIS

./write_configs.pl --input file.xml --output file.conf --xsd_file file --json_file file.json [--help] [--debug]

write_configs.pl --help or `perldoc write_configs.pl` for more information.

=head1 ARGUMENTS

=over 8

=item B<--input>
The name of the XML file to use for values (input.xml)

=item B<--output>
The name of the Apache configuration file to write (output.conf)

=item B<--xsd_file>
The name of the schema validation file (xsd_file.xsd)

=item B<--json_file>
The name of the output JSON file

=back

=head1 OPTIONS

=over 8

=item B<--help>
Prints this help message

=item B<--debug>
Turns on script debugging

=back

=head1 DESCRIPTION

This script:\n
* Reads the given XML file, re-numbers the entry ID numbers in sequence from 1 to eternity:\n
* Takes the ID number and URL values and outputs correctly formatted Apache redirect string into the output file.\n
* Validates the re-generated XML file against given schema\n
* Saves the XML file with updated ID numbers.\n
* Outputs JSON file from the updated XML file.

=cut

