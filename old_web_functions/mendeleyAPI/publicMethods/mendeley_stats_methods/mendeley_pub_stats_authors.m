function [output,status,raw] = mendeley_pub_authors(authStruct,discipline_id,upandcoming)
%mendeley_pub_authors  
%
%   [output,status,raw] = mendeley_pub_authors(authStruct, *discipline_id, *upandcoming)
%
%   Returns list of all-time top authors across all disciplines, 
%   unless optional params used.
%
%   OPTIONAL INPUTS
%   =======================================================================
%   discipline_id :
%   upandcoming   : JAH TODO: what is this?
%
%   OUTPUT EXAMPLE
%   =======================================================================
%
%   See Also: 
%
%   STATUS: Needs example and documentation, error check optional inputs?

mendeley_helper_handleOptionalInputs({'discipline' 'upandcoming'})

URL = 'http://api.mendeley.com/oapi/stats/authors/';

keyboard

%JAH TODO: error check the discipline and upandcoming

myParams = {'discipline' discipline_id 'upandcoming' upandcoming};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);