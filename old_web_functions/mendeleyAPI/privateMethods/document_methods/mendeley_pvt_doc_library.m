function [output,otherStruct] = mendeley_pvt_doc_library(authStruct,page,itemsPerPage)
%mendeley_pvt_doc_library 
%
%   output = mendeley_pvt_doc_library(authStruct,*page,*itemsPerPage)
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
%   page         : (numeric, default 0)
%   itemsPerPage : (numeric, default 20)
%
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-library
%
%   See Also: 
%       mendeley2_pvt_getAllDocIDs
%       mendeley2_pvt_getRangeDocIDs

%openExplorerToMfileDirectory('mendeley_pvt_doc_library')
%mendeley_open_documentation('mendeley_pvt_doc_library')

url = 'http://api.mendeley.com/oapi/library/';
httpMethod = 'GET';

if nargin < 2 || isempty(page)
    page = '';
else
    page = int2str(page);
end

if nargin < 3
    itemsPerPage = '';
else
    itemsPerPage = int2str(itemsPerPage);
end

myParamsPE = {'page' page 'items' itemsPerPage};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);

