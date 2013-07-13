function tagOutput = html_getTagsByProp(webStr,tagName,propName,propValue,varargin)
%getTagsByProp  Returns tag attribute and 
%
%   FORM 1 - filter
%   tagOutput = html_getTagsByProp(webStr,tagName,propName,propValue,varargin)
%
%   FORM 2 - no filtering
%   Leaving propName and propValue empty means there is no filtering of the
%   tags based on a property and its value
%   tagOutput = html_getTagsByProp(webStr,tagName) %
%   tagOutput = html_getTagsByProp(webStr,tagName,'','',varargin)
%
%   FORM 3 - text matching
%   tagOutput = html_getTagsByProp(webStr,tagName,'text contains',propValue,varargin)
%
%   OUTPUTS
%   =======================================================================
%   tagOutput : (structure array)
%       .text   - text encapsulated inside tag (doesn't include tag text)
%       .atts   - attributes of tag (html_getAttributesTag)
%       .bounds - bounds of tag (html_getOpenCloseTag)
%       ---------
%       .links  - present if get_links is true (html_getLinks)
%
%   INPUTS
%   =======================================================================
%   webStr      : text to process
%   tagName     : name of the tag to match (case insensitive)
%   propName    : property to filter by
%   propValue   : property value to match
%                 i.e. get the tag with propName="propValue"
%       
%       SPECIAL FILTERING CASE:
%       special variable "text contains" will search the containing text
%       NOTE: this must have a space inbetween the two words
%
%       POSSIBLE IMPROVEMENT: Expand to exact match, "text is"
%
%   OPTIONAL INPUTS
%   =======================================================================
%   get_links      : (default false)
%   decode_text    : (default false)
%   prev_url       : (default ''), if not empty this will be used to make all
%                    of the links returned
%   case_sensitive : (default false), whether or not propValue match should
%                     be case sensitive
%   no_regex_tag   : (default true), if false then tag could be a regular
%                    expression to match, see html_getOpenCloseTag
%   no_amps_value  : (default true), means the prop value doesn't have 
%                     an ampersand escape
%
%   JAH NOTE: perhaps we should always just encode the input and then
%             this will always be true ...
%
%   See Also:
%       html_getOpenCloseTag
%       html_getAttributesTag
%       html_getLinks

%MLINT
%#ok<*NASGU>  %variable may be unused
%#ok<*UNRCH> %variable may be unreachable

DEFINE_CONSTANTS
get_links        = false;
decode_text      = false;
prev_url         = ''; 
case_sensitive   = false;
no_regex_tag     = true;
no_amps_value    = true;
END_DEFINE_CONSTANTS

if nargin == 2
    propName = '';
    propValue = '';
end

propName   = lower(propName); %Ensures case insensitive matching
searchText = strcmp(propName,'text contains');

%NOTE: This changes
tagBounds = html_getOpenCloseTag(webStr,tagName,no_regex_tag);

if isempty(tagBounds)
    tagOutput = [];
    return
end

nTags   = length(tagBounds);
isMatch = true(1,nTags); %NOTE: This is true in case we are accepting all
%This means we always need to set false below
attCA   = cell(1,nTags);

%I THINK I WANT TO USE THESE
% textCA       = cell(1,nTags);
% textDecodeCA = cell(1,nTags);

%I THINK I WANT THREE SEPARATE LOOPS FOR EACH VERSION ...

for iTag = 1:nTags
    
    curTag  = tagBounds(iTag);

    if ~isempty(propName)
        if searchText
            tempText = webStr(curTag.IopenEnd+1:curTag.Iclose-1);
            tempText = html_encode_decode_amp('decode',tempText);
            if case_sensitive
                isMatch(iTag) = any(strfind(tempText,propValue));
            else
                isMatch(iTag) = any(strfind(lower(tempText),lower(propValue)));
            end
            %This process is expensive, avoid if possible
            if isMatch
                attCA{iTag} = html_getAttributesTag(webStr(curTag.Iopen:curTag.IopenEnd));
            end
        else
            
               attText = webStr(curTag.Iopen:curTag.IopenEnd);
            if no_amps_value && isempty(strfind(attText,propValue))
                   isMatch(iTag) = false;
                   continue
            end
            temp    = html_getAttributesTag(attText);
            attCA{iTag} = temp;
            if case_sensitive
                isMatch(iTag) = isfield(temp,propName) && strcmp(temp.(propName),propValue)
            else
                isMatch(iTag) = isfield(temp,propName) && strcmpi(temp.(propName),propValue);
            end
        end
    else
       attCA{iTag} = html_getAttributesTag(webStr(curTag.Iopen:curTag.IopenEnd));
    end
end

I_match   = find(isMatch);
nMatches  = length(I_match);
tagOutput = struct('text',repmat({''},1,nMatches),'atts','');

for iiMatch = 1:nMatches
    
    curIndex = I_match(iiMatch);
    curTag   = tagBounds(curIndex);
    tempText = webStr(curTag.IopenEnd+1:curTag.Iclose-1);
    
    if decode_text
       tagOutput(iiMatch).text = html_encode_decode_amp('decode',tempText); 
    else
       tagOutput(iiMatch).text = tempText;
    end
    
    %NOTE: We don't want to decode the text until we've
    %identified the links, i.e. the input to the following 
    %function should be tempText, not the decoded version
    %as this could introduce off limit html characters =>  <,>,"
    if get_links 
        tagOutput(iiMatch).links = html_getLinks(tempText,...
            'decode_text',decode_text,'prev_url',prev_url);
    end
    tagOutput(iiMatch).atts   = attCA{curIndex};
    tagOutput(iiMatch).bounds = tagBounds(curIndex);
    if strcmpi(tagOutput(iiMatch).bounds.tagName,'a') && ...
        isfield(tagOutput(iiMatch).atts,'href') && ...
        ~isempty(prev_url)
        tagOutput(iiMatch).atts.href = url_getAbsoluteUrl(prev_url,tagOutput(iiMatch).atts.href);
    end
end


end
