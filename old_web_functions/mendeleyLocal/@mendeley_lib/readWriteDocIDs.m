function idsFromFile = readWriteDocIDs(obj,option,newIDs) %#ok<INUSD>
%readWriteDocIDs
%
%   idsFromFile = readWriteDocIDs(obj,'read')
%
%   OR
%   
%   idsFromFile = readWriteDocIDs(obj,'write',newIDs)
%
%   OUTPUTS
%   ========================================
%   idsFromFile (struct)
%       .values
%       .dates
%   
%   INPUTS
%   ========================================
%   option   : 'read' or 'write'
%   userName : account username


if ischar(obj)
    error('Fix calling function')
end

if ~ismember(nargin,[2 3])
    error('The number of input arguments must be 2 for read, 3 for write')
end

idPath = obj.client_obj.user_docIDs_path;

switch lower(option)
    case 'read'
        if exist(idPath,'file')
            h = load(idPath);
            idsFromFile = h.newIDs;
        else
            idsFromFile = struct('values',[],'dates',[],'lastCheck',0);
        end
    case 'write'
        save(idPath,'newIDs')
    otherwise
        error('Input option must be ''read'' or ''write'', not %s',option)
end