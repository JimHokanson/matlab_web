function [output,extras] = mendeley_pub_search_details(authStruct,id,type)
%mendeley_pub_search  
%
%   [output,status,raw] = mendeley_pub_search_details(authStruct, id, *type)
%
%   Returns citation info for a specific paper, such as authors,
%   publication outlet, year, abstract, PubMed ID if available, etc. Also
%   returns # readers, top 3 discipline stats, top 3 country stats, and top
%   3 education status stats.
%
%   OPTIONAL INPUTS
%   =======================================================================
%   type : if unspecified, canonical id, otherwise
%       - isbn
%       - doi
%       - pmid
%       - scopus
%       - ssm
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

mendeley_helper_handleOptionalInputs({'type'})

if strcmp(type,'uuid')
   type = ''; 
end
myParams = {'type' type};

%JAH TODO: If DOI, need to encode the / first, before passing in ...
if strcmpi(type,'doi')
    id = regexprep(id,'/','%252F');
end

URL = ['http://api.mendeley.com/oapi/documents/details/' ...
    oauth.percentEncodeString(id) '/'];

[output,extras] = mendeley_helper_retrieval('GET',URL,authStruct,myParams,true);