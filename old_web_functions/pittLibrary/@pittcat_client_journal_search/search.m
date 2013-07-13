function search_obj = search(pittcat_client,varargin)
%search
%
%   search(obj)
%
%   See Also:
%       findJournalPages
%       parseInitJournalSearch
%       filterJournalPageResults
%       pittcat_journal_result_page     %Class for results pages
%
%   
%
%   OUTLINE
%   =================================================
%   1) Perform initial search for journal
%       - pittcat_client_journal_search.findJournalPages
%       - 
%
%   NOTE: This flow gets everything, then determines what is good.
%   This code could be sped up significantly 
%
%   Known Callers:
%       pittcat_client.search_pittcat
%
%
%   Class: pittcat_client_journal_search

   in.search_method_override = [];
   in = processVarargin(in,varargin);

   obj = pittcat_client_journal_search(pittcat_client);
   search_obj = obj;

   %JAH TODO: Add JSOUP installed check ... 

   if ~obj.j_obj.isSet
      pittcat_notifier.error('Document must be specified before searching for it in Pittcat')
      return %#ok<*UNRCH>
   end 
   
   if isempty(obj.j_obj.volume)
      pittcat_notifier.error('Currently a document must have a volume specified to match it')
      return
   end

   obj.search_started = true;
   
   if ~isempty(in.search_method_override)
       %JAH TODO: error check this
       obj.search_method = in.search_method_override;
   else 
      obj.search_method = 'by_title';
      if ~isempty(obj.j_obj.issn)
         obj.search_method = 'by_issn';
      else
         obj.search_method = 'by_title'; 
      end
   end

   switch obj.search_method
       case 'by_issn'
          obj.searcher = pittcat_journal_searcher_by_issn(obj.j_obj);
       case 'by_title'
       	  obj.searcher = pittcat_journal_searcher_by_title(obj.j_obj);
   end
   
   if ~obj.searcher.success
       return
   end
   
   %PARSING INDIVIDUAL JOURNAL PAGES
   %=========================================================================================
   pittcat_notifier.status('Parsing Pittcat journal entries');
   obj.j_result_pages = pittcat_journal_result_page(obj.raw_page_texts,obj.prev_urls,obj);

   
   %DETERMINING IF ANY MATCH
   %=========================================================================================
   pittcat_notifier.status('Determining if any matches are present');
   obj.all_results = pittcat_journal_search_result([obj.j_result_pages.holdings],obj.j_obj,obj);

   cur_valid_count = length(obj.good_results);
   
   pittcat_notifier.status('Done searching, %d possible matches found',cur_valid_count);

end