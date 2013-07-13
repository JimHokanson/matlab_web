function [output,otherStruct] = mendeley_pub_search_authored(authStruct,name,page,items,year)
%mendeley_pub_search  
%
%   [output,status,raw] =  mendeley_pub_search_authored(authStruct,name,*page,*items,*year)
%
%   Returns list of publications with that author name.
%
%   OPTIONAL INPUTS
%   =======================================================================
%   page  : (string or integer) page # in the search request
%   items : (string or integer) # items per page
%   year  : (string or integer) year filter
%
%   EXAMPLE OUTPUT
%   =======================================================================
%
%
%   #doc_page: http://apidocs.mendeley.com/home/public-resources/search-authored
%
%   See Also:
%   mendeley_pub_search_terms
%   mendeley_pub_search_details
%   mendeley_pub_search_related
%   mendeley_pub_search_tagged
%   mendeley_pub_search_categories
%   mendeley_pub_search_subcategories

%   openExplorerToMfileDirectory('mendeley_pub_search_authored')
%   mendeley_open_documentation('mendeley_pub_search_authored')

HTTP_METHOD = 'GET';
URL = ['http://api.mendeley.com/oapi/documents/authored/' ...
    oauth.percentEncodeString(name) '/'];

%What this allows is setting optional inputs to null if not specified
mendeley_helper_handleOptionalInputs({'page' 'items' 'year'})
myParams = {'page' page 'items' items 'year' year};

[output,otherStruct] = mendeley_helper_retrieval(HTTP_METHOD,URL,authStruct,myParams,true);
