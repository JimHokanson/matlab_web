function [output,status,raw] = mendeley_pub_stats_tags(authStruct,discipline_id)
%mendeley_pub_stats_tags  
%
%   [output,status,raw] = mendeley_pub_stats_tags(authStruct,discipline_id)
%
%   Returns list of discipline tags for the last 3 weeks.
%
%   INPUTS
%   discipline_id : Should this be discipline??? -> change to be consistent
%   with others????
%
%   EXAMPLE OUTPUTS
%   =======================================================================


URL = ['http://api.mendeley.com/oapi/stats/tags/' discipline_id '/'];
myParams = {};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);