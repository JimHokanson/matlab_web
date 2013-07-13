function text = html_removeTags(text,tagsToRemove,varargin)
%html_removeTags Removes tags from text
%   
%   text = html_removeTags(text,tagsToRemove,varargin)
%
%   This function was originally used to remove search markup that 
%   was applied to make things bold or highlighted or headers (h1,h2), etc
%
%   INPUTS
%   ==================================================================
%   text : text to process
%   tagsToRemove : (cellstr or string) removes tags from text, NOTE: they 
%       MUST currently be bounded tags (i.e. have both an open and close)
%       Regular expressions for each string are allowed -> 'h\d+'
%
%   OPTIONAL INPUTS
%   ==================================================================
%   removeText : (default false), if true, removes text between the tags
%                 as well
%   no_regex_tag :(default false), if true, only a single tag is being
%                  passed in to remove and it contains no regular
%                  expressions (makes things faster), see html_getOpenCloseTag
%
%   IMPROVEMENTS
%   ===================================================================
%   Implement an option which removes all tags (wouldn't remove text),
%   perhaps pass in tagsToRemove as -1
%
%   EXAMPLES
%   ==========================================
%   text = 'Bob is <b>weird</b>';
%   tagsToRemove = {'b'};
%   text = html_removeTags(text,tagsToRemove);
%   text =>
%       'Bob is weird'
%
%   NOTE: 
%
%   text = html_removeTags(text,tagsToRemove,true);
%   text =>
%       'Bob is'


%   See Also: 
%       html_getOpenCloseTag

DEFINE_CONSTANTS
removeText   = false;
no_regex_tag = false;
END_DEFINE_CONSTANTS

if ischar(tagsToRemove)
    tagsToRemove = {tagsToRemove};
end

type = ['(' cellArrayToString(tagsToRemove,'|') ')'];
tagBounds = html_getOpenCloseTag(text,type,no_regex_tag);

if removeText
    I1 = tagBounds.Iopen;
    I2 = tagBounds.IcloseEnd;
else
    I1 = [tagBounds.Iopen tagBounds.Iclose];
    I2 = [tagBounds.IopenEnd tagBounds.IcloseEnd];
end

mask_I = generateIndicesFromRanges(I1,I2);
text(mask_I) = [];

end