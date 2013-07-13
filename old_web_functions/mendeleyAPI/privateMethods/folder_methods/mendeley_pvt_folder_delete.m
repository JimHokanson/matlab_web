function [output,otherStruct] = mendeley_pvt_folder_delete(authStruct,folderID)
%mendeley_pvt_folder_delete
%
%   output = mendeley_pvt_folder_delete(authStruct,folderID)
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

if isnumeric(folderID)
    folderID = sprintf('%ld',folderID);
end

url = ['http://api.mendeley.com/oapi/library/folders/' folderID '/'];
httpMethod = 'DELETE';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);
