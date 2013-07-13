classdef pittcat_journal_searcher_by_issn < pittcat_journal_searcher
    %pittcat_journal_searcher_by_title
    %
    %

    methods
        function obj = pittcat_journal_searcher_by_issn(j_obj)
            
            obj.j_obj = j_obj;
            
            %INITIAL JOURNAL SEARCHING & FILTERING
            %=====================================================================================
            pittcat_notifier.status('Searching for journals that match: %s',obj.j_obj.journal);
            
            formStruct = form_get(obj.KEYWORD_SEARCH__START_URL);
            formStruct = form_helper_selectOption(formStruct,'FLD1','data','ISSN');
            formStruct = form_helper_setTextValue(formStruct,'SAB1',j_obj.issn);
            %formStruct = form_helper_chooseButton( - value is submit ...
            [web_page_text,extras] = form_submit(formStruct);
            pittcat_notifier.status('Parsing search results: %s',obj.j_obj.journal);
            
            [~,nEntries] = pittcat_web_interface.isEntriesPage(web_page_text);
            
            pittcat_notifier.status('Parsing search results page');
            if nEntries == 0
                pittcat_notifier.error('No matches found for requested ISSN')
                return %#ok<UNRCH>
            elseif nEntries == 1
                obj.raw_page_texts = {web_page_text};
                obj.prev_urls      = {extras.url};
            else
                [headers,text_ca,links] = pittcat_web_interface.parseEntriesPage(web_page_text,extras.url,nEntries);
                
                %IMPORTANT
                %=========================================================
                %We're not using a lot of information here ...
                
                %FILTER BY ISSN
                pittcat_notifier.status('Filtering by ISSN');
                
                if ~strcmp(headers(2),'ISSN')
                    error('ISSN column assumption violated')
                end
                
                issn_values = text_ca(:,2);
                
                issn_match = find(strcmp(j_obj.issn,issn_values));
                
                nFiltResults = length(issn_match);
                
                if nFiltResults == 0
                    pittcat_notifier.error('No matches found for requested ISSN')
                    return %#ok<UNRCH>
                else
                    pittcat_notifier.status('Found %d matches for given ISSN',nFiltResults)
                end

                obj.prev_urls      = links(issn_match);
                obj.raw_page_texts = cell(1,nFiltResults);
                for iResult = 1:nFiltResults
                    obj.raw_page_texts{iResult} = urlread2(obj.prev_urls{iResult});
                end

            end
            
            obj.success = true;
            
        end
    end
    
end

