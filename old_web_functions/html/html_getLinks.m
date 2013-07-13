function links = html_getLinks(text,varargin)
%html_getLinks  Returns links with text from web page
%
%   links = html_getLinks(text,varargin)
%
%   OUTPUTS
%   =======================================================================
%   links (structure array)
%       .text - text that the tag encloses
%       .href - link, may be absolute
%       .att  - other attributes
%       .bounds - see html_getOpenCloseTag
%
%   INPUTS
%   =======================================================================
%   text : input string to process 
%
%   OPTIONAL INPUTS
%   =======================================================================
%   decode_text: (default true), if true removes ampersands from text
%   prev_url   : (default ''), if not empty returns links as absolute urls
%                instead of potentially being relative
%
%   EXAMPLE
%   =======================================================================
%   text = 'asdf <a href="/scholar?cites=17856863490770088749">Cited by 3</a> blah';
%   links = html_getLinks(text,'prev_url',prev_url)
%   links =>
%           text: 'Cited by 3'
%           href: [1x102 char]
%            att: [1x1 struct]
%
%   See Also:
%       html_getTagsByProp
%       url_getAbsoluteUrl
%       html_getOpenCloseTag


DEFINE_CONSTANTS
decode_text = true;
prev_url    = '';
END_DEFINE_CONSTANTS

%NOTE: This is a circular call, as this can be called
%by html_getTagsByProp, it is important that get_links is false
tagOutput = html_getTagsByProp(text,'a','','','get_links',false,'decode_text',decode_text);

if isempty(tagOutput)
    links = [];
    return
end

links = struct(...
    'text',{tagOutput.text},...
    'href','',...
    'att','',...
    'bounds',[]);

for iLink = 1:length(links)
   curAtts = tagOutput(iLink).atts; 
   
   links(iLink).bounds = tagOutput(iLink).bounds;
   
   if isfield(curAtts,'href')
      href = curAtts.href;
      curAtts = rmfield(curAtts,'href');
   else
      href = '';
   end
   
   links(iLink).att = curAtts;
   
   if ~isempty(prev_url) && ~isempty(href)
       links(iLink).href = url_getAbsoluteUrl(prev_url,href);
   else
       links(iLink).href = href;
   end
end
