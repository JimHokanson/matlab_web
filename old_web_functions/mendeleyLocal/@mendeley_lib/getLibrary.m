function getLibrary(obj,varargin)
%mendeley_local_getLibrary  Return users library
%
%   lib = getLibrary(obj,varargin)
%
%   USERNAME -> see ...
%
%   OUTPUTS
%   =======================================================================
%   lib : see mendeley_local_initLibStruct
%
%   OPTIONAL INPUTS
%   =======================================================================
%   OPTION : (default 0)
%         - 0, only return the library itself (don't look for new or old entries)
%         - 1, get latest updates to library, don't retrieve new information
%         - 2, get all documents (update old documents)

%   SHOW_N : (default false), if true shows the # of newly added documents
%
%   IMPLEMENTATION NOTES:
%   =======================================================================
%   %1) .created should be tracked between versions
%   %2) all fields except .format should be arrays with length equal to the
%   %number of entries
%
%   See Also:
%   .updateDocIDsUser
%   .readWriteLibrary
%   mendeley_local_initLibStruct
%   mendeley_pvt_doc_details

in.OPTION = 0;
in.SHOW_N = false;
in = processVarargin(in,varargin);

%Miscellaneous junk
%----------------------------------------------------------
readLibraryFromDisk(obj);       %Populate object from disk

switch in.OPTION
    case 0
        return
    case 1
        allDocIDs = updateDocIDsUser(obj); %Get all ids
        if isequal(obj.ids,allDocIDs)
            return
        end
    case 2
        writeLibraryToDisk(obj,true);      %ARCHIVE OLD CONTENT
        allDocIDs = updateDocIDsUser(obj); %Get all ids
end


%Determining what is new and what is old
%----------------------------------------------------
[nNew,nOld,allDocIDs] = helper__determineNewAndDeletedEntries(obj,allDocIDs);

if in.OPTION == 2 && nNew == 0
    writeLibraryToDisk(obj); 
    return
end

%3) ADD ON NEW ONES AT END
%----------------------------------------------------
forceReloadAll = in.OPTION == 2;
helper__getNewEntries(obj,nOld,allDocIDs,forceReloadAll)

if in.SHOW_N && nNew ~= 0
    fprintf('Added %d docs for user: %s\n',nNew,obj.client_obj.user_name)
end

writeLibraryToDisk(obj);

end

function helper__getNewEntries(obj,nOld,allDocIDs,forceReloadAll)
%
%   JAH TODO: Document function ...
%
%

N_DISPLAY = 50;

%Update:
%   - entry information
%   - last read
%   - id at entry

obj.created(nOld+1:end) = now;

if forceReloadAll
    startIndex = 1;
else
    startIndex = nOld + 1;
end

nIDs = length(allDocIDs);
for iEntry = startIndex:nIDs
    if mod(iEntry,N_DISPLAY) == 0
        fprintf('Retrieving article %d of %d\n',iEntry,nIDs);
    end
    
    curDocID = allDocIDs(iEntry);
    curEntry = mendeley_pvt_doc_details(obj.client_obj.auth_struct,curDocID);
    
    obj.entries{iEntry}  = curEntry;
    obj.lastRead(iEntry) = now;
    obj.ids(iEntry)      = curDocID;
end

parseEntries(obj,startIndex:nIDs)

end


function [nNew,nOld,allDocIDs] = helper__determineNewAndDeletedEntries(obj,allDocIDs)
%helper__determineNewAndDeletedEntries
%
%   
%   OUTPUTS
%   =============================
%   nNew :
%   nOld :
%   allDocIDs :

nIDs = length(allDocIDs);
if ~isempty(obj.ids)
    stillPresent = ismember(obj.ids,allDocIDs);
    isNew        = ~ismember(allDocIDs,obj.ids);
    nOld = length(find(stillPresent));
    nNew = nIDs - nOld;
    
    fn = obj.ENTRY_SIZED_VARIABLES;
    
    if nNew > 0 || ~all(stillPresent)
        for iField = 1:length(fn)
            curField = fn{iField};
            if iscell(obj.(curField))
               temp = repmat({''},[1 nNew]);
            else
               temp = zeros(1,nNew,class(obj.(curField)));
            end
            obj.(curField) = [obj.(curField)(stillPresent) temp];
        end    
    end
    
    allDocIDs = [obj.ids(1:nOld) allDocIDs(isNew)];
    
else
    %Nothing present, all ids are new
    initLibStruct(obj,length(allDocIDs));
    nNew = nIDs;
    nOld = 0;
end



end


