function [output,otherStruct] = mendeley_pvt_profile_info(authStruct,profile_id)
%mendeley_pvt_profile_info
%
%   output = mendeley_pvt_profile_info(authStruct)
%   
%   OUTPUTS
%   =======================================================================
%
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%
%   See Also: 

%TODO
%-> still missing section and subsection


if ~exist('profile_id','var')
    profile_id = 'me';
elseif isnumeric(profile_id)
    profile_id = int2str(profile_id);
end

url = sprintf('http://api.mendeley.com/oapi/profiles/info/%s/',profile_id);
httpMethod = 'GET';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);

