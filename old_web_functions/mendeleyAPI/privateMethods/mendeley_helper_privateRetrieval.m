function [output,otherStruct,raw] = mendeley_helper_privateRetrieval(httpMethod,url,authStruct,myParamsPE)
%
%   JAH TODO: Document me
%

fprintf(2,'Please update call to use helper_retrieval\n');

raw = '';
[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE);