function url = url_getURLfromParsed(s)
%url_getURLfromParsed Reconstructs a url from a parsed structure
%
%   NOTE: This should recompute the url from the structure
%   
%
%   url = url_getURLfromParsed(s)
%   
%   See Also:
%       url_getAbsoluteUrl
%       url_parseURL


%JAH TODO: I am not sure if this function is finished
url = [s.urlRoot s.fullPath];
if ~isempty(s.query)
    url = [url '?' s.query];
end

if ~isempty(s.id)
    url = [url '#' s.id];
end
