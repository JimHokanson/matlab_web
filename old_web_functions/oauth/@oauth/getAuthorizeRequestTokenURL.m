function urlAddress = getAuthorizeRequestTokenURL(obj,copyToClipboard)
%getAuthorizeRequestTokenURL Creates Authorization url 
%
%   urlAddress = getAuthorizeRequestTokenURL(obj, *copyToClipboard)
%
%   OUTPUTS
%   =============================================================
%   urlAddress : address to enter into the browser to get verifier
%
%   OPTIONAL INPUTS
%   =============================================================
%   copyToClipboard : default false, if true copies address to clipboard
%                     for easier copy/paste operation

%JAH TODO: Add on check for validity of request token

%         oauth_request_token
%         oauth_request_token_secret
%         oauth_request_ttl = -1
%         oauth_request_set_time

if isempty(obj.oauth_request_token)
    error('Request token must be obtained first, see method getRequestToken')
end

if ~exist('copyToClipboard','var')
   copyToClipboard = false; 
end

%JAH TODO: check expiration time

urlAddress = sprintf('%s?oauth_token=%s',obj.AUTH_URL,obj.oauth_request_token);
if copyToClipboard
   clipboard('copy',urlAddress) 
end