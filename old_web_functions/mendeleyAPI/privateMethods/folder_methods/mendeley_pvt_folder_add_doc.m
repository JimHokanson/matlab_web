function [output,otherStruct] = mendeley_pvt_folder_add_doc(authStruct,folderID,docID)
%mendeley_pvt_folder_add_doc
%
%   output = mendeley_pvt_folder_add_doc(authStruct)
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

if isnumeric(docID)
    docID = sprintf('%ld',docID);
end

url = ['http://api.mendeley.com/oapi/library/folders/' folderID '/' docID '/'];
httpMethod = 'POST';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);