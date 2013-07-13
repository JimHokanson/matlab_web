function saveRequestToFile(obj)
%pittcat_saveSuccessfulRequestToFile
%
%   JAH TODO: Document
%
%
%   class: pittcat_journal_search_result

pcat_user = obj.requesting_client.user_obj;
%Class pittcat_user

if exist(pcat_user.filepath_requestsMadeLog,'file')
    h = load(pcat_user.filepath_requestsMadeLog);
    docs     = h.docs;
    curCount = h.curCount;
    if isfield(h,'locs')
       locs  = h.locs;
       dates = h.dates;
    end
else
    docs  = cell(1,1000);
    locs  = cell(1,1000);
    dates = cell(1,1000);
    curCount = 0;
end

curCount = curCount + 1;
if curCount > length(docs)
    docs  = [docs cell(1,1000)];
    locs  = [locs cell(1,1000)];
    dates = [dates cell(1,1000)];
end

docs{curCount}  = obj.j_obj; %#ok<NASGU>
locs{curCount}  = obj.location; %#ok<NASGU>
dates{curCount} = datestr(now); %#ok<NASGU>

save(pcat_user.filepath_requestsMadeLog,'docs','locs','dates','curCount');

end