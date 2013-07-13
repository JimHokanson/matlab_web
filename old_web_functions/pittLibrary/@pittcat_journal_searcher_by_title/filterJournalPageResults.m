function filterJournalPageResults(obj)
%filterJournalPageResults
%
%   This function reduces the # of entries to actually look at
%
%   reducedMatches = filterJournalPageResults(obj)
%
%   OUTLINE
%   ===========================================================
%   At this point we have a bunch of different possible journals. Instead
%   of requesting the information for each, and parsing the content, we
%   first try and remove journals that are likely not to be a match.
%
%   ALGORITHM
%   ===========================================================
%   1) No Electronic Resources
%   2) Must contain searched journal name in FULL TITLE NAME
%
%   MIGHT IMPROVE ALGORITHM WITH TIME
%
%   Should probably sort by unique journal
%   and then if failure to match on volume on any
%   ignore the rest

ELEC_STR = '[electronic resource]';

if obj.nInitJournalsFound == 1
    obj.filtered_journal_results       = obj.init_journal_results;
    obj.filtered_journal_match_success = true;
end

initMatches = obj.init_journal_results;

%1)
badOptions = cellfun(@(x) ~isempty(strfind(x,ELEC_STR)),{initMatches.full_title});
initMatches(badOptions) = [];

%2)
badOptions = cellfun(@(x) ~abbrStringMatch2(obj.journal_search_term,x,'CASE_SENSITIVE',false),{initMatches.full_title});
obj.filtered_journal_results = initMatches(~badOptions);

obj.filtered_journal_match_success = ~all(badOptions);

if ~obj.filtered_journal_match_success
   handleError(obj,0,'No journals remained after filtering, see explainFilteredJournalMatchFailure for help');
end

end