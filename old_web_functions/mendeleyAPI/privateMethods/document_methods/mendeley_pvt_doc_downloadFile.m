function [output,otherStruct] = mendeley_pvt_doc_downloadFile(authStruct,id,file_hash,group_id)
%mendeley_pvt_doc_downloadFile  Returns
%
%   [output,status,raw] = mendeley_pvt_doc_downloadFile(authStruct, id, file_hash, *saveStruct, *group_id)
%   
%   OUTPUTS
%   =======================================================================
%
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%   id           : document id
%   file_hash    : hash of the file to download, obtained from document details
%
%   OPTIONAL OUTPUTS
%   =======================================================================
%   saveStruct : 
%       .save
%       .savePath
%  
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/download-file
%
%
%   See Also: 

%   openExplorerToMfileDirectory('mendeley_pvt_doc_downloadFile')
%   mendeley_open_documentation('mendeley_pvt_doc_downloadFile')

if isnumeric(id)
    id = sprintf('%ld',id);
end

if ~exist('group_id','var')
    url = ['http://www.mendeley.com/oapi/library/documents/' id '/file/' file_hash '/'];
else
    if isnumeric(group_id)
        group_id = sprintf('%ld',group_id);
    end
    url = ['http://www.mendeley.com/oapi/library/documents/' id '/file/' file_hash '/' group_id];
end
httpMethod = 'GET';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE,...
    false,'CAST_OUTPUT',false);
