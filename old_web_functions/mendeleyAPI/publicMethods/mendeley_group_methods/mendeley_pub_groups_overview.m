function [output,status,raw] = mendeley_pub_groups_overview(authStruct,page,items,cat_id)
%mendeley_pub_groups_search  
%
%   mendeley_pub_groups_search(authStruct,page,items,cat_id)
%
%   This method will return a list of public groups available on Mendeley
%   sorted by number of members.
%
%   OPTIONAL INPUTS
%   ==========================================
%   page
%   items
%   cat_id
%
%   EXAMPLE OUTPUTS
%   =======================================================================
%


mendeley_helper_handleOptionalInputs({'page' 'items' 'cat_id'})
myParams = {'page' page 'items' items 'cat_id' cat_id};

URL = 'http://api.mendeley.com/oapi/documents/groups/';

[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);