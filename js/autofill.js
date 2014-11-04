/*
 # This file is part of Whitebox Navigation.
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
 # For the practical reasons to keep the file sizes small, you can remove this notice
 # from the production file as long as you keep it in your derivative works.
 */


$(document).ready(function () {
// instantiate the bloodhound suggestion engine
    var engine = new Bloodhound({
        limit: 80,
        datumTokenizer: function (datum) {
            // merge display_string and tokens
            ds = Bloodhound.tokenizers.whitespace(datum.string);
            t = Bloodhound.tokenizers.whitespace(datum.token.join(' '));
            return ds.concat(t);
            // console.log("datum.token: ", datum.token);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: {
            url: "../data/json/entries.json",
            ttl: 86400000,  // cache time for local storage in milliseconds (1 day by default)
            filter: function (data) {
                return $.map(data.jdata.entries, function (entry) {
                    return {
                        string: entry.display_string,
                        token: entry.tokens,
                        rid: entry.id,
                        type: entry.type
                    };
                });
            }
        }
    });

    // initialize the bloodhound suggestion engine
    engine.clearPrefetchCache();
    engine.initialize();

    // instantiate the typeahead UI
    $('#prefetch #queries_query_query').typeahead(
        {
            hint: true,
            highlight: true,
            minLength: 1
        },
        {
            name: 'engine',
            displayKey: 'string',
            source: engine.ttAdapter(),
            templates: {
                header: '',
                empty: 'search the site',
                suggestion: Handlebars.compile('{{string}}'),
                footer: ''
            }
        }).on('typeahead:selected typeahead:autocompleted', function (event, datum) {
            $('#prefetch #queries_query_query').val(datum.string);
            $('#id').val(datum.rid);
            currInput = $("#prefetch #queries_query_query").val();
        }).on('keyup', function () {
            if (typeof currInput !== "undefined") {
                if (($('.tt-suggestion').length === 0) && ($('#prefetch #queries_query_query').val() != currInput)) {
                    $('#id').val('');
                }
            }
        })
    ;
});