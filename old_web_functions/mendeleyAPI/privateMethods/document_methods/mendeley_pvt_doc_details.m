function [output,otherStruct] = mendeley_pvt_doc_details(authStruct,id)
%mendeley_pvt_docDetails  Returns details of a reference entry
%
%   [output,otherStruct] = mendeley_pvt_docDetails(authStruct,id)
%   
%   OUTPUTS
%   =======================================================================
%   output =>  
%      total_results: 1284
%        total_pages: 65
%       current_page: 0
%     items_per_page: 20
%       document_ids: {1x20 cell}, strings of ids
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%   id           : document id string
%
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-library-document-details
%
%   See Also: 
%       mendeley2_pvt_getAllDocIDs
%       mendeley_pvt_userLibrary

%   openExplorerToMfileDirectory('mendeley_pvt_doc_details')
%   mendeley_open_documentation('mendeley_pvt_doc_details')

if isnumeric(id)
    id = int2str(id);
end

baseUrl = 'http://api.mendeley.com/oapi/library/documents/';
url = sprintf('%s/%s/',baseUrl,id);
httpMethod = 'GET';

myParamsPE = {}; 

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);
