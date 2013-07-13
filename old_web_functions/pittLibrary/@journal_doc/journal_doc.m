classdef journal_doc < handle
    %journal_doc
    
    %   openExplorerToMfileDirectory('journal_doc')
    
    properties
        title
        volume
        issue
        year
        pages
        authors  %format ????, cellstr???
        journal    %NOTE: This should be a class on its own
        issn
        doi
        pmid
        publisher  %Really doesn't belong here
    end
    
    properties (Dependent)
        allAuthors    
    end
    
    methods 
        function value = get.allAuthors(obj)
           value = cellArrayToString(obj.authors,', '); 
        end
    end
    
    methods
        
        function flag = isSet(obj)
            
            %Wish I had a better way of doing this
            %perhaps a property enumeration method?
            
            flag = ~isempty(obj.title) || ...
               ~isempty(obj.volume)|| ...
               ~isempty(obj.issue) || ...
               ~isempty(obj.year)  || ...
               ~isempty(obj.pages) || ...
               ~isempty(obj.authors) || ...
               ~isempty(obj.journal) || ...
               ~isempty(obj.issn) || ...
               ~isempty(obj.doi) || ...
               ~isempty(obj.pmid);

        end
        
        function obj = journal_doc
           reinitialize(obj) 
        end
        
        function set.title(obj,value)
            obj.title = regexprep(value,'\n|\r','');
        end
        
        function set.year(obj,value)
            if isnumeric(value)
                value = int2str(value);
            end
            obj.year = value;
        end
        
        function data = getDisplayTable(obj)
           data = {
               'title'  obj.title
               'volume' obj.volume
               'issue'  obj.issue
               'year'   obj.year
               'pages'  obj.pages
               'authors' cellArrayToString(obj.authors,',')
               'journal' obj.journal
               'issn'   obj.issn
               'doi'    obj.doi
               'pmid'   obj.pmid
               'publisher' obj.publisher};
        end
        
        function reinitialize(obj)
            obj.title   = '';
            obj.volume  = '';
            obj.issue   = '';
            obj.year    = '';
            obj.pages   = '';
            obj.authors = {};
            obj.journal = '';
            obj.issn    = '';
            obj.doi     = '';
            obj.pmid    = ''; 
        end
    end
    
    methods (Static)
        %This really doesn't belong here, not sure where to go with it
        function str = removeLeadingArticle(str)
            %journal_doc.removeLeadingArticle
            
            %JAH TODO: expand to leading articles %??? Not sure what I mean here
           %JAH TODO: Check size
           if strcmpi(str(1:4),'The ')
               str = str(5:end);
            end 
        end
    end
    
end

