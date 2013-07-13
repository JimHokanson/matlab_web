function [output,otherStruct] = mendeley_pvt_folder_rem_doc(authStruct,folder_id,doc_id)
%mendeley_pvt_folder_rem_doc  Removes 
%
%   output = mendeley_pvt_folder_rem_doc(authStruct)
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

if isnumeric(folder_id)
    folder_id = int2str(folder_id);
end

if isnumeric(doc_id)
    doc_id = int2str(doc_id);
end

url = ['http://api.mendeley.com/oapi/library/folders/' folder_id '/' doc_id '/'];
httpMethod = 'DELETE';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);