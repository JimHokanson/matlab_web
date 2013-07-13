function [output,status,raw] = mendeley_pub_search_subcategories(authStruct,cat_id)
%mendeley_pub_categories  
%
%   [output,status,raw] = mendeley_pub_search_subcategories(authStruct,cat_id)
%
%   Returns sub categories of a main category.
%
%   OUTPUT EXAMPLE
%   =======================================================================
%   
%   See Also:
%   mendeley_pub_search_terms
%   mendeley_pub_search_details
%   mendeley_pub_search_related
%   mendeley_pub_search_authored
%   mendeley_pub_search_tagged
%   mendeley_pub_search_categories
%   mendeley_pub_search_subcategories

URL = ['http://api.mendeley.com/oapi/documents/subcategories/' ...
    oauth_percentEncodeString(cat_id) '/'];
myParams = {};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);
