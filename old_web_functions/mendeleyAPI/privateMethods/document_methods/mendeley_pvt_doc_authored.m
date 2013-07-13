function [output,otherStruct] = mendeley_pvt_doc_authored(authStruct)
%mendeley_pvt_doc_authored  Returns
%
%   output = mendeley_pvt_doc_authored(authStruct)
%   
%   OUTPUTS
%   =======================================================================
%   output = 
%      total_results: 1
%        total_pages: 1
%       current_page: 0
%     items_per_page: 20
%       document_ids: {'2937576181'}
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-authored
%   
%   
%   
%   See Also: 

%openExplorerToMfileDirectory('mendeley_pvt_doc_authored')
%mendeley_open_documentation('mendeley_pvt_doc_authored')

url = 'http://api.mendeley.com/oapi/library/documents/authored/';
httpMethod = 'GET';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);