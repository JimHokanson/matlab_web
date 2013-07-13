function [output,status,raw] = mendeley_pub_groups_people(authStruct,id)
%mendeley_pub_groups_people  
%
%   [output,status,raw] = mendeley_pub_groups_people(authStruct,id)
%
%   This method will return all types of users involved in a group. The new
%   groups can have different types of users within a group based on
%   permission levels: owner, admins, members and followers. Groups must
%   always have an owner, and therefore, it will be always returned.
%
%   EXAMPLE OUTPUT
%   =======================================================================


URL = ['http://api.mendeley.com/oapi/documents/groups/' id '/people/'];
myParams = {};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);