function baseString = createBaseString(obj)
%createBaseString  This function returns the base string used for calculating the signature
%
%   Constructs the base signature string as defined by Section 3.4.1.1
%   of the Oauth Protocol
%
%   baseString = oauth_createBaseString(obj,http_method)
%
%   INPUTS
%   =================================================================
%   http_method : HTTP request method, 'GET','POST', etc.
%
%   USED OBJECT PROPERTIES
%   ==================================================================
%   current_request_type : helps to resolve url and parameters
%
%   url    : the base url, sans request params, it is ASSUMED that this 
%            follows 3.4.1.2 specifications, see note below
%            example -> http://www.mendeley.com/oauth/access_token/
%
%   PARAMS NOTES:
%   ====================================================
%   See http://tools.ietf.org/html/rfc5849#section-3.4.1.3.1 as to what
%   should be included in params
%   - include parameters for authorization
%   - include parameters that are being encoded
%
%   URL NOTES: how to get a valid url
%   =====================================================
%   - scheme & host must be lowercase
%   - exclude port if to port 80 HTTP or port 443 HTTPS
%   - otherwise the port must be included
%   - exclude request parameters
%           
%
%   See Also: 
%       oauth.normalizeParams
%       oauth.percentEncodeString
%
%   http://tools.ietf.org/html/rfc5849#section-3.4.1.1

%Parameter retrieval
%------------------------------------------------------------
params = [obj.auth_params.params obj.user_params.params];


%Creation of the base string
%----------------------------------------------------
baseString = oauth_params.normalizeParams(params);
baseString = [obj.http_method '&' oauth.percentEncodeString(obj.url) '&' oauth.percentEncodeString(baseString)];
