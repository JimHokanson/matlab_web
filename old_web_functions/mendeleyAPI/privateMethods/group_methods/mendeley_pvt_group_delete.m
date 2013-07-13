function [output,otherStruct] = mendeley_pvt_group_delete(authStruct,group_id)
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
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-library-delete-group
%
%   See Also: 

%   openExplorerToMfileDirectory('mendeley_pvt_group_delete')
%   mendeley_open_documentation('mendeley_pvt_group_delete')

if isnumeric(group_id)
    group_id = int2str(group_id);
end

url        = sprintf('http://api.mendeley.com/oapi/library/groups/%s/',group_id);
httpMethod = 'DELETE';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);
