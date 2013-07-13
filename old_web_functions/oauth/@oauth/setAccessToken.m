function setAccessToken(obj,token,secret)
%setAccessToken Sets access token properties
%
%   setAccessToken(obj,token,secret)
%
%   INPUTS
%   =========================================================
%   token  : (string)
%   secret : (string)

   obj.oauth_access_token = token; 
   obj.oauth_access_token_secret = secret; 
end