function [output,otherStruct] = mendeley_pvt_group_list(authStruct)
%
%
%
%   
%   OUTPUTS
%   =======================================================================
%
%   INPUTS
%   =======================================================================
%
%
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-library-groups
%
%   See Also: 

%   openExplorerToMfileDirectory('mendeley_pvt_group_list')
%   mendeley_open_documentation('mendeley_pvt_group_list')


url = 'http://api.mendeley.com/oapi/library/groups/';
httpMethod = 'GET';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);
