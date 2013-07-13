function [output,otherStruct] = mendeley_pvt_folder_list(authStruct)
%mendeley_pvt_folder_list  Returns
%
%   output = mendeley_pvt_folder_list(authStruct)
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

url = 'http://api.mendeley.com/oapi/library/folders/';
httpMethod = 'GET';
myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);
