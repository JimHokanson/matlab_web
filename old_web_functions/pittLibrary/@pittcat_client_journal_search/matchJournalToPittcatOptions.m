function options = matchJournalToPittcatOptions(obj,journalSearchResults)

%NOT YET USED:
%=======================================
%Could be used to rank display of options

error('Not yet implemented')

% % % % %MATCHING RANK: assign score to each ...
% % % % %----------------------------------------------------------------
% % % % %1) has volume and year
% % % % %2) has volume but not year
% % % % %3) neither, just journal sounds good (indicate best row where it should be)
% % % % %4) the nothing entry type
% % % % 
% % % % options = [];
% % % % %type, location, line, type_str, link, allEntryInfo
% % % % 
% % % % if isempty(journalSearchResults)
% % % %    
% % % %    return
% % % % end
% % % % 
% % % % keyboard
% % % % 
% % % % nOptions = sum(arrayfun(@(x) length(x.parsed.loc_entries),journalSearchResults));
% % % % 
% % % % options = struct(...
% % % %     'id',num2cell(nOptions),...
% % % %     'type',[],...
% % % %     'location',[],...
% % % %     'line',[],...
% % % %     'type_str','',...
% % % %     'link','',...
% % % %     'allEntryInfo',[]);
% % % % 
% % % % for iPage = 1:length(journalSearchResults)
% % % %     curResult = journalSearchResults(iPage);
% % % %     loc_entries = curResult.parsed.loc_entries;
% % % %     for iLoc = 1:length(loc_entries)
% % % %         %JAH TODO: Right here
% % % %     end
% % % % end