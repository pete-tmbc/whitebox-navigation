Whitebox Navigation "The Search on Steroids"
============================================

Whitebox Navigation merges site navigation and search into a single easy to use interface. With the aid of Twitter's Typeahead and Bloodhound a humble search box is turned into an intuitive, easy to use and mobile friendly navigation tool. In cases where user don't find match for their query, the navigation tool reverts back to the humble search box.

On a mobile devices, the Whitebox Navigation saves screenspace and improves your visitors' experience by not getting on the way, taking away the need to try to fit a complicated menu structure on a small screen and the user's need to try to figure out where your menus are and how your navigation works. In addition, if the user want to cancel the navigation choice, they can do that with one click without losing the focus on the current page.

The Whitebox Navigation takes away the need for the user to try to figure out where the content is in the site's structure. Using the Whitebox Navigation you can concentrate on releasing content instead of spending time and effort into creating an elaborate navigation structure that most probably doesn't scale with your site.

While it would be easy to use JavaScript redirections instead of server side redirects, it would be waste. Using server side redirects allows you to use the same redirect schema from using the XML file with XSLT to create traditional navigation menus and id value, that is used for detecting the redirection, for generic short URLs.

Unlike popular dynamic search used on many shopping sites, the Whitebox Navigation is not dynamic in that you have to maintain and update the entries manually (or automatically if you want to do bit of work to write something that generates the XML source file). The reasons for this are simple:
<ul>
<li>this is a navigation tool, initially based on a concept that you are visiting a website because you want to <td>do</td> something instead of just browsing</li>
<li>tomatos, tomatoes. We all think and express ourselves differently so a sentence that memans one thig to me may mean something different to another person. Whitebox Navigation allows you to have multiple sentences/ strings all pointing to same target</li>
<li>we assume that there is just one target, just like in traditional navigation</li>
</ul>


Features
========

<ul>
<li>allows additional tokens to be used to match alternative keywords to display string</li>
<li>uses Handlebars templates for result list customisation</li>
<li>no matches messaging can be customised</li>
<li>automatic JSON file generation</li>
<li>automatic Apache config file generation</li>
<li>automatic sorting (renumbering) of the entries ensuring that no duplicate redirect IDs can exist</li>
<li>automatic XML validation before conversion</li>
<li>full control over the output file names and paths</li>
</ul>

Dependencies
============

<u>JavaScript</u>:
<ul>
<li>jQuery 1.10 or higher</li>
<li>Typeahead Bundle 10 or higher (alternatively Typeahead core & Bloodhound)</li>
<li>Handlebars</li>
</ul>

<u>Perl</u>:
<ul>
<li>Getopt::Long</li>
<li>File::Copy</li>
<li>Pod::Usage</li>
<li>XML::LibXML</li>
<li>Google::Data::JSON</li>
<li>JSON::Schema</li>
</ul>

To Do
=====

Things I may or may not do, or am thinking would be nice feature to add.
<ul>
<li>add JSON schema validation</li>
<li>replace Google::Data::JSON to remove need for JSON cleanup</li>
<li>add checks if output file(s) already exists and allow option for backing old ones up</li>
<li>add automatic upload to chosen server</li>
<li>option to generate multiple JSON files based on entry type allowing grouping with Handlebars</li>
</ul>

Where I Wouldn't Use This
=========================

If your site is highly dynamic, constantly changing/ growing content or you have multiple possible targets for same term, e.g. on shopping sites, Whitebox Navigation may not be the best tool for navigation (unless you script something to automatically update the data).

Where I Will Use This
=====================

Everywhere were the site structure is static and where I can create a traditional menu structure to link to every page, and where each page is unique it its purpose, e.g. on a local government websites.

Want to Make This Better?
=========================

Suggestions, feedback and contributions are all welcome.

See it in Action
================

http://www.tmbc.gov.uk/



