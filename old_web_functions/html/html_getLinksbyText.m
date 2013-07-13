function links = html_getLinksbyText(text,toMatch,caseMatch,varargin)
%html_getLinksbyText
%   
%   links = html_getLinksbyText(text,toMatch,*caseMatch,varargin)
%
%   NOTE: one could also implement this using other functions but this one
%   should be a bit faster (I think)
%
%   I could be convinced this function is obsolete and we should use
%   html_getTagsByProp
%
%   OUTPUTS
%   ====================================================================
%   links : (cellstr), cell array of urls in href, urls are not necessarily
%           absolute
%
%   INPUTS
%   ====================================================================
%   text    : web text
%   toMatch : string to match inside of the anchor tag
%
%   OPTIONAL INPUTS
%   ====================================================================
%   caseMatch   : (default false), if true text and toMatch are matched
%                  with case sensitivity
%
%   via varargin
%   escapeMatch : (default true), if true runs regexptranslate on input
%                 i.e. treat the input as literal, not as a regular
%                 expression text
%
%   IMPROVEMENTS
%   =================================================
%   1) Technically this function won't work if href is not enclosed with
%      quotes
%
%   EXAMPLE
%   ===================================================
%   text  = '<a href="cheese.html">hi mom</a>';
%   links = html_getLinksbyText(text,'hi');
%   links => 
%       {'cheese.html'}


if ~exist('caseMatch','var')
    caseMatch = false;
end

DEFINE_CONSTANTS
escapeMatch = true;
END_DEFINE_CONSTANTS

%<a STUFF href="GRAB"

if escapeMatch
    toMatch = regexptranslate('escape',toMatch);
end

%
PAT = '<a.*?href="(?<link>[^"]*?)".*?>(?<text>.*?)</a>';

aTags = regexp(text,PAT,'names');

if caseMatch
    mask = arrayfun(@(x) ~isempty(regexp(x.text,toMatch,'once')),aTags);
else
    mask = arrayfun(@(x) ~isempty(regexpi(x.text,toMatch,'once')),aTags);
end

links = {aTags(mask).link};