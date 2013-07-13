classdef pittcat_journal_searcher < handle
    %pittcat_journal_searcher
    %
    %   This is the class that does the searching and parsing of the
    %   initial search page ...
    %
    %   EXTENDED BY
    %   pittcat_journal_searcher_by_issn
    %   pittcat_journal_searcher_by_title
    
    properties
       raw_page_texts
       prev_urls
       j_obj
       success = false  %Whether or not any journals results were found 
    end
    
    properties (Hidden,Constant)
        SS_ADDRESS             = 'http://rt4rf9qn2y.search.serialssolutions.com/';
        PITTCAT_ADDRESS        = 'http://pittcat.pitt.edu/';
        NO_JOURNALS_FOUND_TEXT = 'Your search was not successful'; 
        KEYWORD_SEARCH__START_URL   = 'http://pittcat.pitt.edu/cgi-bin/Pwebrecon.cgi?DB=local&PAGE=bbSearch'
    end
    
    properties
        opt_MAX_JOURNAL_SEARCH_COUNT = '20';    
    end
    
    methods
        function set.opt_MAX_JOURNAL_SEARCH_COUNT(obj,value)
            if isnumeric(value)
                value = int2str(value);
            end
            obj.opt_MAX_JOURNAL_SEARCH_COUNT = value;
        end 
    end
    
    methods
    end
    
end

