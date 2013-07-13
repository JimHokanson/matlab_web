classdef pittcat_client_journal_search < handle
    %pittcat_client_journal_search
    %

    
    %MAIN METHOD
    %===========================================
    %
    %   pittcat_client_journal_search.search(pittcat_client_obj,varargin)
    
    %IMPROVEMENTS
    %====================================================================
    %1) Use ISSN in search, need to parse detailed pages instead of the
    %basic page ...
    
    %RERFERENCES TO OTHER OBJECTS
    properties
       parent           %(class pittcat_client)
       j_obj            %(class journal_doc)
       j_result_pages   %(class pittcat_journal_result_page)
       all_results      %(class pittcat_journal_search_result)
       searcher         %(class pittcat_journal_searcher)
       search_method    %see obj.SEARCH_METHODS
       search_started = false
    end

    properties (Constant,Hidden)
        SEARCH_METHODS = {'by_title' 'by_issn'};
    end
    
    properties (Dependent)
       journal_search_success 
       good_results     %(class pittcat_journal_search_result)
       raw_page_texts
       prev_urls
    end
    
    %GET METHODS =============================================
    methods 
        function value = get.journal_search_success(obj)
           value = obj.searcher.success;
        end
        
        function value = get.good_results(obj) 
           if isempty(obj.all_results)
               value = [];
           else
               value = obj.all_results([obj.all_results.is_match]);
           end
        end
        
        function value = get.raw_page_texts(obj)
           if isempty(obj.searcher)
              value = [];
           else
              value = obj.searcher.raw_page_texts;
           end 
        end
        
        function value = get.prev_urls(obj)
           if isempty(obj.searcher)
              value = [];
           else
              value = obj.searcher.prev_urls;
           end
        end
        
    end

    methods (Access=private)
        function obj = pittcat_client_journal_search(pittcat_client)
            
           obj.j_obj   = pittcat_client.j_obj;
           obj.parent  = pittcat_client;
        end
    end
    
    methods (Static)
       [search_result,search_obj] = search(pittcat_client)
    end
    
    
end

