URLFinderAndVerifier
====================
Copyright (c) 2013 David Hoerl, all rights reserved. (see URLSearcher files for usage license)

Find URLs in arbitrary text, test if a given string is a valid URL.

When searching on the web, the curious developer finds hundreds of regular expressions claiming to properly process URLs, and its virtually impossible to test their compliance as the specification is quite complex. One such interesting site is managed by Mathias Bynens (link below), where I found a slew or URLs to use in the Unit Test.

I had a need for a URL verification algorithm, and was overjoyed to trip on Jeff Roberson's site, as he has a slew of regular expression, one for each component of the spec, and he in the end builds them up into a final regular expression that can handle anything in the spec.

Many developers though do not want to process text to the full standard; like me, they are looking to extract (or validate) http and https requests. So this project supports arbitrary regular expression construction, but using various component expressions and gluing them together.

Current options:

- allow any scheme, or just http/https
- require "// and an authority, or allow any path
- ignore or include query strings
- ignore or include fragments
- "Entry Mode", where the second '/' is required (by someone obstensibly typing into a text box)
- 'Unicode Mode' where URLs (actually IRIs) with Unicode characters will get detected (you'd have to encode them for use), ie http://www.example.com/düsseldorf?neighbourhood=Lörick

Options you could expore:
- modifying the regular expressions to return the scheme, authority, and path as capture groups
- ditto for the query and fragment strings

Jeff Roberson's Regular Expressions: http://jmrware.com/articles/2009/uri_regexp/URI_regex.html
RFC Reference: http://tools.ietf.org/html/rfc3986
ABNF Reference: http://en.wikipedia.org/wiki/Augmented_Backus–Naur_Form
Test URLS From: http://mathiasbynens.be/demo/url-regex

RFC-3986 Section 3.3
   The generic URI syntax consists of a hierarchical sequence of
   components referred to as the scheme, authority, path, query, and
   fragment.

      URI         = scheme ":" hier-part [ "?" query ] [ "#" fragment ]

      hier-part   = "//" authority path-abempty
								 / path-absolute
								 / path-rootless
								 / path-empty

   [ED: note that the alternatives are all "path..." items, authority is always required
        but can be a zero length string.]

   The scheme and path components are required, though the path may be
   empty (no characters).  When authority is present, the path must
   either be empty or begin with a slash ("/") character.  When
   authority is not present, the path cannot begin with two slash
   characters ("//").  These restrictions result in five different ABNF
   rules for a path (Section 3.3), only one of which will match any
   given URI reference.

   The following are two example URIs and their component parts:

         foo://example.com:8042/over/there?name=ferret#nose
         \_/   \______________/\_________/ \_________/ \__/
          |           |            |            |        |
       scheme     authority       path        query   fragment
          |   _____________________|__
         / \ /                        \
         urn:example:animal:ferret:nose
