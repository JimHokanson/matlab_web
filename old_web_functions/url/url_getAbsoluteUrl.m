function nextURL = url_getAbsoluteUrl(origURL,urlOnPage)
%url_getAbsoluteUrl Constructs url handling relative links
%
%   nextURL = url_getAbsoluteUrl(origURL,urlOnPage)
%   
%   INPUTS
%   =======================================================================
%   origURL  : url of page that yield form or link
%   urlOnPage: a link or url from a form on the page
%
%   OUTPUTS
%   =======================================================================
%   nextURL  : url of resource with relative links removed
%
%   See Also:
%       url_parseURL
%       url_getURLfromParsed

output  = url_parseURL(urlOnPage,origURL);
nextURL = char(output.java_obj);



