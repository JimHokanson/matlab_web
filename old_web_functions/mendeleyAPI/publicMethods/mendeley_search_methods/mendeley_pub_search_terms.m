function [output,otherStruct] = mendeley_pub_search_terms(authStruct,terms,page,items)
%mendeley_pub_search  
%
%   [output,status,raw] = mendeley_pub_search_terms(authStruct, terms, *page, *items)
%
%   Returns list of canonical ids together with the title, publication outlet, 
%   authors, year, doi (if available) and mendeley catalog url. 
%   More detailed document information can then be retrieved with 
%   the document_details method.
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
%   mendeley_pub_search_related
%   mendeley_pub_search_authored
%   mendeley_pub_search_tagged
%   mendeley_pub_search_categories
%   mendeley_pub_search_subcategories
FIX_FORWARD_SLASH = true;
URL = ['http://api.mendeley.com/oapi/documents/search/' ...
    oauth_percentEncodeString(terms,FIX_FORWARD_SLASH) '/'];

mendeley_helper_handleOptionalInputs({'page' 'items'})
myParams = {'page' page 'items' items};

[output,otherStruct] = mendeley_helper_retrieval('GET',URL,authStruct,myParams,true);