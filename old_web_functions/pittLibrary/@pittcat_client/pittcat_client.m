classdef pittcat_client < handle
    %pittcat_client
    
    %AREAS TO FURTHER SUBDIVIDE
    %=========================================
    %search
    %document request
    %document retrieval - LOW PRIORITY
    
    %METHODS IN OTHER FILES
    %=========================================
    %openExplorerToMfileDirectory('pittcat_client')
    %   - getJournalStruct
    %   - pittcat_determineJournalSelection
    %   - search
    %   -
    
    properties
        j_obj       %(Class journal_doc)
        search_obj  %(Class  
        user_obj    %(Class pittcat_user)
    end
    
    properties (Hidden)
        gui_obj
        in_gui_mode
    end
    
    methods (Hidden)
        function setGUIobj(obj,value)
           obj.gui_obj     = value;
           obj.in_gui_mode = true;
        end 
    end
    
    methods
        
        function launch_gui(obj)
           pittcat_client_gui.run(obj) 
        end
        
        function show_search_results_gui(obj)
           %NOTE: Should check that search is valid ... 
           pittcat_journal_search_result_gui.run(obj)
        end
        
        function obj = pittcat_client(varargin)
            %JAH TODO: Finish documentation
            
            in.gui_obj = [];
            in.verbose = false;
            in = processVarargin(in,varargin);
            
            obj.in_gui_mode = ~isempty(in.gui_obj);
            
            if obj.in_gui_mode
                obj.gui_obj = in.gui_obj;
            end
            
            %Initialize with empty journal entry
            obj.j_obj    = journal_doc;
            
            obj.user_obj = pittcat_user;
        end
        
        function methods(obj)
            %PLOTTING METHODS
            groups(1).name = 'Initialization';
            groups(1).fncs = {'pittcat_client' 'launch_gui'};
            groups(end+1).name = 'Searching';
            groups(end).fncs = {'search' 'show_search_results_gui'};
            groups(end+1).name = 'Journal Methods';
            groups(end).fncs = {'populateDocFromPMID' 'populateDocFromBibtex'};
            groups(end+1).name = 'unused';
            groups(end).isSpecial = true;
            dispMethodsObject2(obj,groups)
        end
        
    end
    
    %USER METHODS ---------------------------------------------------
    
    
    %JOURNAL METHODS ------------------------------------------------
    methods
        function populateDocFromPMID(obj,pmid)
           getJournalStructFromPubmed(obj.j_obj,pmid) 
        end
        function populateDocFromBibtex(obj)
           docFromBibtex(obj.j_obj)
        end
    end
    
    methods (Static)
        function show_page(web_page_str)
            %show_page
            %
            %   Opens variable as webpage
            %
            %   show_page(web_page_str)
            %   JAH TODO: Document function
            %
            
            if nargin == 0
                error('Text input must be given')
            end
            
            if isjava(web_page_str) 
                %Java string ...
                web_page_str = char(web_page_str);
            end
            
            filePath = fullfile(tempdir,'html_debug.htm');
            fid = fopen(filePath,'w+');
            fwrite(fid,web_page_str,'char');
            fclose(fid);
            
            openWebBrowser(filePath)
        end
    end
end

