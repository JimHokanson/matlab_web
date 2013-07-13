function range_info = mendeley2_pvt_getRangeDocIDs(authStruct)
%mendeley2_pvt_getRangeDocIDs  Returns all document ids from a particular user
%
%   allDocIDs = mendeley2_pvt_getRangeDocIDs(authStruct)
%
%   JAH TODO: Update documentation

%
%
%   OUTPUTS
%   =======================================================================
%   range_info: (struct)
%     first: 4558258091
%      last: 2477333831
%         n: 1997
%
%   INPUTS
%   =======================================================================
%   authStruct
%
%
%   See Also: mendeley_getUserLibrary

%Let's first query how many we have, this command will do that ...
libStruct = mendeley_pvt_doc_library(authStruct,0,1);

range_info = struct(...
    'first',str2double(libStruct.document_ids{1}),...
    'last','',...
    'n',libStruct.total_results);

%NOTE: This call can take a long time ...
libStruct = mendeley_pvt_doc_library(authStruct,libStruct.total_results-1,1);
range_info.last = str2double(libStruct.document_ids{1});


