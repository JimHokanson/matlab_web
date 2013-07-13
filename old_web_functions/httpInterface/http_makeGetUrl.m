function newURL = http_makeGetUrl(url,params,varargin)
%http_makeGetUrl  Creates a url for GET method with query
%
%   newURL = http_makeGetUrl(url,params)
%
%   OUTPUT
%   =========================================
%   newURL : url for making get request
%
%   INPUTS
%   =========================================
%   url    : base url without request parameters
%   params : cell array of property names/value pairs 
%
%   OPTIONAL INPUTS
%   =========================================
%   param_encode_option - (default 1)
%       1 - typical url mode
%       2 - oauth encoding
%
%   SEE ALSO:
%       http_paramsToQuery

DEFINE_CONSTANTS
param_encode_option = 1;
END_DEFINE_CONSTANTS

endString = http_paramsToString(params,param_encode_option);
newURL    = [url '?' endString];

end

