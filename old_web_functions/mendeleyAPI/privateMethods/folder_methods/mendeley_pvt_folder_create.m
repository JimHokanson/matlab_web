function [output,otherStruct] = mendeley_pvt_folder_create(authStruct,folderName)
%mendeley_pvt_folder_create
%
%   output = mendeley_pvt_folder_create(authStruct)
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
httpMethod = 'POST';

folderJSON = mat2json(struct('name',folderName));

myParamsPE = {'folder',folderJSON};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);