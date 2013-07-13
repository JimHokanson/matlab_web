classdef pittcat_journal_result_page < pittcat_result_page
    %pittcat_journal_result_page
    %
    %   pittcat_journal_result_page < pittcat_result_page
    
    properties
        title
        publisher
        issn
        former_title
    end

    methods
        function obj = pittcat_journal_result_page(page_texts,urls,p_obj)
            if nargin == 0
                return
            end
            
             nObjs = length(page_texts);
             obj(nObjs) = pittcat_journal_result_page;
             for iObj = 1:nObjs
                initResultObject(obj(iObj),page_texts{iObj},urls{iObj},p_obj) 
             end
        end
        
        function parse(obj)
           
            header = obj.gen_header_struct;
            if isfield(header,'Title')
                obj.title = header.Title.values{1};
            end
            if isfield(header,'Publisher')
                obj.publisher = header.Publisher.values{1};
            end
            if isfield(header,'ISSN')
               obj.issn = header.ISSN.values{1};
            end
            if isfield(header,'Former_Title')
               obj.former_title = header.Former_Title.values{1};
            end
        
            obj.holdings = pittcat_library_holding_journal(obj);

        end
    end
    
end

