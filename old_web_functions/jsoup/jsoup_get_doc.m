function doc_obj = jsoup_get_doc(raw_text,prev_url)
%jsoup_get_doc Get's html document as jsoup object
%
%   This function is currently in place just
%   so I don't have to remember all this
%
%   CALLING FORMS
%   ====================================================
%   doc_obj = jsoup_get_doc(raw_text,prev_url)
%
%   doc_obj = jsoup_get_doc(url_retrieve)
%
%   NOTE: Could make this a class with methods ...

deprecatedWarning('','jsoup.getDoc','Just moving the function')

if nargin == 1
   URL = raw_text;
   [raw_text,extras] = urlread2(URL);
   prev_url = extras.url;
end

html_parser_obj = org.jsoup.parser.Parser.htmlParser;      
doc_obj         = html_parser_obj.parseInput(raw_text,prev_url);