URLFinderAndVerifier
====================
Copyright (c) 2013 David Hoerl, all rights reserved. (see URLSearcher files for usage license)

Find URLs in arbitrary text, test if a given string is a valid URL.

When searching on the web, the curious developer finds hundereds of regular expressions claiming to properly process URLs, and its virtually impossible to test their compliance as the specification is quite complex. I had a need for a URL verification algorithm, and was overjoyed to trip on Jeff Roberson's site, as he has a slew of regular expression, one for each component of the spec, and he i the end builds them up into a final regular expression that can handle anything.

Many developers though do not want to process text to the full standard; like me, they are looking to extract (or validate) http and https requests. So this project supports arbitrary regular expression construction, but using various component expressions and gluing them together.

Current options:

- allow any scheme, or just http/https
- require "// and an authority, or allow any path
- ignore or include query strings
- ignore or include fragments

Options you could expore:
- modifying the regular expressions to retun the scheme, authority, and path as capture groups
- ditto for the query and fragment strings
- require a terminating '/' in the path-abempty component, to enable ENTER buttons for people tying in URLs


Jeff Roberson's Regular Expressions: http://jmrware.com/articles/2009/uri_regexp/URI_regex.html
RFC Reference: http://tools.ietf.org/html/rfc3986
ABNF Reference: http://en.wikipedia.org/wiki/Augmented_Backus–Naur_Form

RFC-3986 Section 3.3
   The generic URI syntax consists of a hierarchical sequence of
   components referred to as the scheme, authority, path, query, and
   fragment.

      URI         = scheme ":" hier-part [ "?" query ] [ "#" fragment ]

      hier-part   = "//" authority path-abempty
                  / path-absolute
                  / path-rootless
                  / path-empty

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
