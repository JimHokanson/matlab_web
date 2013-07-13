function [output,status,raw] = mendeley_pub_search_categories(authStruct)
%mendeley_pub_categories  
%
%   [output,status,raw] = mendeley_pub_search_categories(authStruct)
%
%   Returns list of main categories and their IDs.
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
%   mendeley_pub_search_subcategories

URL = 'http://api.mendeley.com/oapi/documents/categories/';
myParams = {};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);
