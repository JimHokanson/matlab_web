function [output,status,raw] = mendeley_pub_search_tagged(authStruct,tag,page,items,cat,subcat)
%mendeley_pub_search  
%
%   [output,status,raw] = mendeley_pub_search_tagged(authStruct,tag,*page,*items,*cat,*subcat)
%
%   Returns list of papers tagged by users with query term. Papers can be
%   filtered by providing either category or subcategory ids.
%
%   OPTIONAL INPUTS
%   =======================================================================
%   page   : (string or integer) page # in the search request
%   items  : (string or integer) # items per page
%   cat    :
%   subcat :
%
%   EXAMPLE OUTPUT
%   =======================================================================
%
%
%   See Also:
%   mendeley_pub_search_terms
%   mendeley_pub_search_details
%   mendeley_pub_search_related
%   mendeley_pub_search_authored
%   mendeley_pub_search_categories
%   mendeley_pub_search_subcategories

URL = ['http://api.mendeley.com/oapi/documents/search/' ...
    oauth_percentEncodeString(tag) '/'];

mendeley_helper_handleOptionalInputs({'page' 'items' 'cat' 'subcat'})
myParams = {'page' page 'items' items 'cat' cat 'subcat' subcat};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);