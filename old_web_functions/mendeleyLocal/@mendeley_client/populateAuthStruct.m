function populateAuthStruct(obj,isPublic)
%populateAuthStruct  Populates Mendeley authorization struct
%
%   populateAuthStruct(obj,*isPublic)
%   
%   This method retrieves the authorization information necessary for
%   making calls in Mendeley
%   
%   OPTIONAL INPUTS
%   =======================================================================
%   isPublic : (default false), if true doesn't populate user specific values
%
%   See Also:
%       oauth.createAuthStruct
%
%   9/24/2012 JAH: Cleaned up documentation


if ~exist('isPublic','var')
   isPublic = false; 
end

authPath = obj.user_creds_path;
apiPath  = obj.api_creds_path;

%Convert this to the auth struct
if isPublic
    t1 = struct('oauth_access_token','','oauth_access_token_secret','');
else
    t1 = getPropFileAsStruct(authPath);
end
t2 = getPropFileAsStruct(apiPath);

obj.auth_struct = oauth.createAuthStruct(...
    t2.consumerKey,t2.consumerSecret,t1.oauth_access_token,t1.oauth_access_token_secret);
end

