function allDocIDs = mendeley2_pvt_getAllDocIDs(authStruct)
%mendeley2_pvt_getAllDocIDs  Returns all document ids from a particular user
%
%   allDocIDs = mendeley2_pvt_getAllDocIDs(authStruct)
%
%   OUTPUTS
%   =======================================================================
%   allDocIDs : (double), numerical value of ids
%
%   INPUTS
%   =======================================================================
%   authStruct
%
%   See Also: 


%Let's first query how many we have, this command will do that ...
libStruct = mendeley_pvt_doc_library(authStruct,0,1);

%NOTE: This call can take a long time ...
libStruct = mendeley_pvt_doc_library(authStruct,0,libStruct.total_results);
allDocIDs = libStruct.document_ids;
allDocIDs = cellfun(@str2double,allDocIDs);

