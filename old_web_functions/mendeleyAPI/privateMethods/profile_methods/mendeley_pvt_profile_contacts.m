function [output,otherStruct] = mendeley_pvt_profile_contacts(authStruct)
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%
%   See Also: 

url = 'http://api.mendeley.com/oapi/library/folders/';
httpMethod = 'GET';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);

