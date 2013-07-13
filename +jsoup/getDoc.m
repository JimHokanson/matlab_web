function doc_obj = getDoc(varargin)
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
%   IMPLEMENTATION NOTES:
%   ==================================================================
%   1) I could also use the jsoup GET function, but I have less control
%   over it. I'm a bit curious as to the speed differences between the two.
%   By using urlread2 I can always add on extra inputs for processing ...
%   An alternative view is that by passing in the raw text and prev_url I
%   should instead have the first input method rely solely on jsoup ...
%   i.e. if nargin == 1, use JSOUP
%       CODE: Document doc = Jsoup.connect("http://en.wikipedia.org/").get();
%   

if nargin == 1
   URL = varargin{1};
   [raw_text,extras] = urlread2(URL);
   prev_url = extras.url;
elseif nargin == 2
   raw_text = varargin{1};
   prev_url = varargin{2};
else
    error('Unepected # of inputs')
end

html_parser_obj = org.jsoup.parser.Parser.htmlParser;      
doc_obj         = html_parser_obj.parseInput(raw_text,prev_url);