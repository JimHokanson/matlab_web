function [new_doc,isNew] = mendeley_local_updateID(USER_NAME,id)
%mendeley_local_updateID
%
% JAH TODO: Finish documentation

lib   = mendeley_local_readWriteLibrary('read',USER_NAME);

if ischar(id)
    id = str2double(id);
end

if lib.format ~= 2
   warning('mLocal:UpdateID',...
       'Code written for format version 2');
   %lib.ids -> a double
   %lib.entries -> cell array, unformatted return
end

I_Doc = find(lib.ids == id,1);
if isempty(I_Doc)
    error('Requested id not found in library')
end

authStruct = mendeley_local_getAuthStruct(USER_NAME);
new_doc = mendeley_pvt_doc_details(authStruct,id);

isNew = ~isequal(lib.entries{I_Doc},new_doc);

lib.entries{I_Doc}  = new_doc;
lib.lastRead(I_Doc) = now;

mendeley_local_readWriteLibrary('write',USER_NAME,lib);

end