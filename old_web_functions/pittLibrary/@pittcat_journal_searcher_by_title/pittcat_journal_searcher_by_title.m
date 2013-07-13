classdef pittcat_journal_searcher_by_title < pittcat_journal_searcher
    %pittcat_journal_searcher_by_title
    %
    %
    
    %INITIAL JOURNAL SEARCH ===============================================
    %FUNCTION: findJournalPages
    properties
       journal_search_term      %How the journal was located, search term used
       resolver_used            %whether or not the journal had to be resolved
       resolved_journal_found   %If the resolver was used, this indicates if the resolver found anything
       init_journal_match_success  %Whether or not a journal match was found
       init_journal_search_text %text from the initial search, raw form
       init_search_result_url   
    end
    
    %FILTERING JOURNALS ===================================================
    %FUNCTION: filterJournalPageResults
    properties
       nInitJournalsFound
       no_journal_results_bug
       init_journal_results     %parsing of the raw text
       filtered_journal_results %reducing the # of journal options
       filtered_journal_match_success
    end
    
    methods
        function obj = pittcat_journal_searcher_by_title(j_obj)
            
           obj.j_obj = j_obj;
            
           %INITIAL JOURNAL SEARCHING & FILTERING
           %=====================================================================================
           pittcat_notifier.status('Searching for journals that match: %s',obj.j_obj.journal);
           findJournalPages(obj)

           if ~obj.init_journal_match_success
              return 
           end

           parseInitJournalSearch(obj)
           pittcat_notifier.status('%d possible journals found',obj.nInitJournalsFound);

           %NOTE: We may already have the raw text, or we may have a page which
           %lists a bunch of possible journals whose pages we need to get
           if ~obj.no_journal_results_bug %/feature

              filterJournalPageResults(obj)

              %Get raw text for each result and the url
              nFiltResults  = length(obj.filtered_journal_results);

              pittcat_notifier.status('Filtered down to %d, retrieving page info for each',nFiltResults);

              if nFiltResults == 0
                  return
              end
              
              obj.prev_urls      = cell(1,nFiltResults);
              obj.raw_page_texts = cell(1,nFiltResults);
              for iResult = 1:nFiltResults
                    obj.prev_urls{iResult}      = url_getAbsoluteUrl(obj.init_search_result_url,obj.filtered_journal_results(iResult).jLink);
                    obj.raw_page_texts{iResult} = urlread2(obj.prev_urls{iResult});
              end
           end
           
           obj.success = true;
           
        end
    end
    
end

