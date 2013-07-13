function [output,status,raw] = mendeley_pub_groups_documents(authStruct,group_id,details,page,items)
%mendeley_pub_groups_documents  
%
%   [output,status,raw] = mendeley_pub_groups_documents(authStruct,group_id,*details,*page,*items)
%
%   Returns list of documents ids within a public group. It is possible to
%   retrieve documents details in the same request setting the optional
%   parameter "details" to true.
%
%   OPTIONAL INPUTS
%   =======================================================================
%
%   EXAMPLE OUTPUTS
%   =======================================================================


URL = ['http://api.mendeley.com/oapi/documents/groups/' group_id '/docs/']; 
mendeley_helper_handleOptionalInputs({'details' 'page' 'items'})

if ~isempty(details) && ~ischar(details)
    if details
        details = '1';
    else
        details = '0';
    end
end


myParams = {'details' details 'page' page 'items' items};
[output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams);