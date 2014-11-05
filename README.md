# Whitebox Navigation - Natural Language Navigation

I want to:
   * buy a house
   * pay my council tax
   * read about new legislation
   * read news

When we visit a site, it always is because we want to do something whilst there. Why is it then that once arrived, we are forced to do "Home -> Business -> Building Control -> Building Control Applications -> ..."? And when we turn to search in frustration, a simple query such as "find my local library" returns tens, if not hundreds of results we have to go through to find the correct one?

Whitebox Navigation was born from the realisation that using tree structure navigation or forcing the user to read through search results to get where they want is inefficient, time consuming and pointless if and when we can take the user from A to B shortest possible route while allowing them to use natural language to get there.

## What Does It Do?

Whitebox Navigation merges site navigation and search into a single easy to use interface. With the aid of the Twitter's Typeahead and Bloodhound a humble search box is turned into an intuitive, easy to use and mobile friendly navigation tool. In cases where user don't find match for their query, the navigation tool reverts back to the search box.

On a mobile devices, the Whitebox Navigation saves screenspace and improves your visitors' experience by not getting on the way. It takes away the need to try to fit a complicated menu structure on a small screen and removes the user's need to try to figure out where your menus are, and how your navigation works. In addition, if the user wants to cancel the navigation choice, they can do that with one click without losing the focus on the content. No more up and down, or left and right, scrolling!

The Whitebox Navigation simply takes away the need for the user to try to figure out how your navigation works. For you, using the Whitebox Navigation you can concentrate on releasing content instead of spending time and effort into creating an elaborate navigation structure that most probably doesn't scale with your site.

## Multiple Uses

While it would be easy to use JavaScript redirections instead of server side redirects, it would be waste of work done and inflexible. Using server side redirects allows you to use the same redirect schema for multiple purposes; from using the XML file with XSLT to create traditional navigation menus to creating generic short URLs by using the ID value in your links (http://www.tmbc.gov.uk?id=1) for example.

Unlike popular, dynamic search used on many shopping sites, the Whitebox Navigation is not dynamic in that you have to maintain and update the entries manually (or automatically if you want to write something that generates the XML source file). The reasons for this are simple:

   * this is a navigation tool, initially based on a concept that you are visiting a website because you want to **do** something instead of just browsing
   * tomatos - tomatoes; football - soccer, city centre - city center. Because spelling varies and we think and express ourselves differently, a sentence that means one thing to me may mean something different to another person. Whitebox Navigation allows you to have multiple sentences/ strings all pointing to same target, or using tokens, to include spelling variations
   * we assume that there is just one target, just like in traditional navigation


## Features

   * allows additional tokens to be used to match alternative keywords to display string
   * uses Handlebars templates for result list customisation
   * no matches messaging can be customised
   * automatic JSON file generation
   * automatic Apache config file generation
   * automatic sorting (renumbering) of the entries ensuring that no duplicate redirect IDs can exist
   * automatic XML validation before conversion
   * full control over the output file names and paths

## Dependencies

### <u>JavaScript</u>:

   * jQuery 1.10 or higher
   * Typeahead Bundle 10 or higher (alternatively Typeahead core & Bloodhound)
   * Handlebars

### <u>Perl</u>:

   * Getopt::Long
   * File::Copy
   * Pod::Usage
   * XML::LibXML
   * Google::Data::JSON

## To Do

Things I may or may not do, or am thinking would be nice feature to add.

   * add JSON schema validation
   * replace Google::Data::JSON to remove need for JSON cleanup
   * add checks if output file(s) already exists and allow option for backing old ones up
   * add automatic upload to chosen server
   * option to generate multiple JSON files based on entry type allowing grouping with Handlebars
   * add option to intercatively update URLs if '?' is missing

## Where I Wouldn't Use This

If your site is highly dynamic, constantly changing/ growing content or you have multiple possible targets for same term, e.g. on shopping sites, Whitebox Navigation may not be the best tool for navigation (unless you script something to automatically update the data).

## Where I Will Use This

Everywhere were the site structure is static and where I can create a traditional menu structure to link to every page, and where each page is unique it its purpose, e.g. on a local government websites.

## Want to Make This Better?

Suggestions, feedback and contributions are all welcome.

## See it in Action

http://www.tmbc.gov.uk/

