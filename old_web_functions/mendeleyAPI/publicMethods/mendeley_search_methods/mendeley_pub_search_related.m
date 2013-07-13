function [output,status,raw] = mendeley_pub_search_related(authStruct,id,page,items)
%mendeley_pub_search  
%
%   [output,status,raw] = mendeley_pub_search_related(authStruct, id, *page, *items)
%
%   Returns list of up to 20 research papers related to the queried canonical id
%
%   OPTIONAL INPUTS
%   =======================================================================
%   page  : (string or integer) page # in the search request
%   items : (string or integer) # items per page
%
%   EXAMPLE OUTPUT
%   =======================================================================
%
%
%   See Also:
%   mendeley_pub_search_terms
%   mendeley_pub_search_details
%   mendeley_pub_search_authored
%   mendeley_pub_search_tagged
%   mendeley_pub_search_categories
%   mendeley_pub_search_subcategories 

URL = ['http://api.mendeley.com/oapi/documents/related/' ...
    oauth_percentEncodeString(id) '/'];

mendeley_helper_handleOptionalInputs({'page' 'items'})
myParams = {'page' page 'items' items};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);