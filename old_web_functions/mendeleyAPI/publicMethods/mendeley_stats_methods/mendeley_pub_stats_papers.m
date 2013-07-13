function [output,status,raw] = mendeley_pub_stats_papers(authStruct,discipline_id,upandcoming)
%mendeley_pub_stats_papers  
%
%   [output,status,raw] = mendeley_pub_stats_papers(authStruct, *discipline_id, *upandcoming)
%
%   Returns list of all-time top papers across all disciplines, 
%   unless optional params used.
%
%   OPTIONAL INPUTS
%   =======================================================================
%   discipline_id :
%   upandcoming   :
%   
%   EXAMPLE OUTPUT
%   =======================================================================
%
%


URL = 'http://api.mendeley.com/oapi/stats/papers/';

mendeley_helper_handleOptionalInputs({'discipline_id' 'upandcoming'})

myParams = {'discipline' discipline_id 'upandcoming' upandcoming};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);