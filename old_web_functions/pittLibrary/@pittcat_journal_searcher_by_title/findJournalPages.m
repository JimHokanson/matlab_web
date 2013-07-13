function findJournalPages(obj)
%findJournalPages
%
%   POPULATES
%   =======================================
%   .journal_search_term
%   .resolver_used
%   .resolved_journal_found
%   
%   class: pittcat_journal_searcher_by_title

docStruct = obj.j_obj;
obj.journal_search_term = journal_doc.removeLeadingArticle(docStruct.journal);

%PERFORM INITIAL JOURNAL SEARCH
%==========================================================================
formStruct = form_get(obj.PITTCAT_ADDRESS);
formStruct = form_helper_setTextValue(formStruct,'Search_Arg',obj.journal_search_term); %Search for this journal
formStruct = form_helper_selectOption(formStruct,'Search_Code','value','JALL');     %Search journal titles
formStruct = form_helper_setTextValue(formStruct,'CNT',obj.opt_MAX_JOURNAL_SEARCH_COUNT); %Return this many results ...

[journalSearchText,extras_fs] = form_submit(formStruct);

%Change to using: [flag,value] = pittcat_web_interface.isEntriesPage(raw_text)

journalMatchFound = isempty(strfind(journalSearchText,obj.NO_JOURNALS_FOUND_TEXT));

%RESOLVE JOURNAL MATCH IF FAILED
%--------------------------------------------------------------------------
%This code attemps to resolve the journal if no matches are given with
%the name returned from another source
%Example: The Annals of otology, rhinology, and laryngology
%-> need to search as: Annals of otology, rhinology & laryngology
%
%I HAD SOME SERIOUS PROBLEMS WITH:
%The Journal of comparative neurology'
%
%See more in pittcat_client.resolveJournal

obj.resolver_used = ~journalMatchFound;

if obj.resolver_used
   results = resolveJournal(docStruct); 
   obj.resolved_journal_found = ~isempty(results);
   
   if obj.resolved_journal_found
       if length(results) > 1
          %JAH TODO: Show what was returned ...
          handleError(obj,1,'Unmatched journal is now returning many results, only searching for the 1st entry')
       end
       obj.journal_search_term = results(1).title;
       formStruct              = form_helper_setTextValue(formStruct,'Search_Arg',journal_search_term);
       [journalSearchText,extras_fs] = form_submit(formStruct);
       journalMatchFound   = isempty(strfind(journalSearchText,obj.NO_JOURNALS_FOUND_TEXT));
   end
end

obj.init_search_result_url = extras_fs.url_obj;

obj.init_journal_match_success = journalMatchFound;

if ~obj.init_journal_match_success
    %JAH TODO: Add link that makes everything more explicit ...
    %Sort of like a debug mode ...
   pittcat_notifier.error('Unable to find the requested journal: "%s"',docStruct.journal)
else
   obj.init_journal_search_text = journalSearchText;
end