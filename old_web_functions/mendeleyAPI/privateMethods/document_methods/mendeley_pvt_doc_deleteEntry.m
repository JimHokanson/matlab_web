function [output,otherStruct] = mendeley_pvt_doc_deleteEntry(authStruct,id)
%mendeley_pvt_doc_authored  Returns
%
%   [output,otherStruct] = mendeley_pvt_doc_deleteEntry(authStruct,id)
%
%   OUTPUTS
%   =======================================================================
%   output : true if success
%
%   INPUTS
%   =======================================================================
%
%
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-library-remove-document
%
%   See Also:

if isnumeric(id)
    id = sprintf('%ld',id);
end

url = ['http://api.mendeley.com/oapi/library/documents/' id '/'];
httpMethod = 'DELETE';

myParamsPE = {};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE,false);



