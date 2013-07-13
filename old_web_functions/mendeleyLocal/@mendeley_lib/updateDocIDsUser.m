function allDocIDs = updateDocIDsUser(obj)
%mendeley_local_updateDocIDsUser  
%
%   [newIDs,allDocIDs] = mendeley_local_updateDocIDsUser(USER_NAME)
%
%   This function gets new document ids from the last time this function
%   was called. It also updates all of these ids on disk.
%
%   OUTPUTS
%   =======================================================================
%   newIDs    : (double array), new ids since last call
%   allDocIDs : (double array), list of all ids
%
%   INPUTS
%   =======================================================================
%   USER_NAME : (string), user name
%
%   See Also:
%       mendeley2_pvt_getAllDocIDs
%       mendeley_local_readWriteDocIDs
%       mendeley_local_getAuthStruct
%
%   IMPLEMENTATION NOTES
%   ========================================
%   1) Makes a call to mendeley2_pvt_getAllDocIDs, THIS IS SLOW
%   2) Attempts to speed this up by sorted IDS failed, ids are not sorted
%   3) 

%Reading from file
idStruct   = readWriteDocIDs(obj,'read');
%.values    : array of ids
%.dates     : Matlab dates on when these were read
%.lastCheck : Time this was last called

%Call to Mendeley
allDocIDs  = sort(mendeley2_pvt_getAllDocIDs(obj.client_obj.auth_struct));

obj.last_id_check = datestr(now);

%NOTE: This functionalitiy is very similar to
%mendeley_lib.getLibrary.helper__determineNewAndDeletedEntries  ....
if ~isequal(allDocIDs(:),idStruct.values(:))

    %Now, let's put the old dates in the correct location
    %Any new entries will be assigned a date of 'now()'
    newDates  = zeros(1,length(allDocIDs));

    [isPresent,loc] = ismember(idStruct.values,allDocIDs);

    %Remove values that are no longer present
    idStruct.values(~isPresent) = [];
    idStruct.dates(~isPresent)  = [];
    loc(~isPresent) = [];

    newDates(loc) = idStruct.dates;
    newDates(newDates == 0) = now;

    idStructNew = struct('values',allDocIDs,'dates',newDates,'lastCheck',now);

    %Write to file
    readWriteDocIDs(obj,'write',idStructNew);
end


