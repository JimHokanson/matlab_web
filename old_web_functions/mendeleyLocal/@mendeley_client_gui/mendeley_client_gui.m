classdef mendeley_client_gui < handle
    %
    %   STATUS:
    %   ==================================================
    %   set.user_options - needs to be finished ...
    
    %HANDLES
    %=========================================
    %.pm_select_user  - user selection menu
    %.button_refreshLibrary
    %.button_Search
    %.text_authorSearch
    %.text_yearSearch
    %.pmenu_DocType
    %.button_clearSearch
    %.table_searchResults
    
    properties (Constant,Hidden)
        NULL_USER     = '-- select --'
        ALL_DOC_TYPES_OPTION = 'all';
    end
    
    properties
        m_file_root   %MENDELEY_FILE_ROOT in user constants
        fig_handle
        h
        user_name     %(name of current user)
        client        %(class mendeley client)
        user_options  %(cellstr), list of available users to work with ...
        user_available_doc_types
    end

    methods
        function obj = mendeley_client_gui(user_name)
            
%             persistent local_obj
%             
%             %JAH TODO: Fix this ...
%             if ~isempty(local_obj)
%                 obj = local_obj;
%                 %Maybe raise figure, what if the figure is deleted
%                 return
%             else
%                 local_obj = obj;
%             end
            
            if ~exist('user_name','var')
                user_name = '';
            end
            
            
            obj.m_file_root = getUserConstants('-MENDELEY_FILE_ROOT');
            
            gui_path       = mendeley_client_gui.getMainFigPath;
            obj.fig_handle = hgload(gui_path);
            obj.h          = guihandles(obj.fig_handle);
            setappdata(obj.fig_handle,'obj',obj);
            
            %1) populate user menu
            updateUserOptions(obj,user_name)
            
            
            

            
            %2) Setup presentation
            clearSearchBoxes(obj)
            
            %3) Callbacks
            set(obj.h.button_refreshLibrary,'Callback',@mendeley_client_gui.CB_refreshLibrary);
            set(obj.h.button_Search,'Callback',@mendeley_client_gui.CB_search);
            set(obj.h.button_clearSearch,'Callback',@mendeley_client_gui.CB_clearSearch);            
            
            %pm_select_user
            
            % %            set(obj.fig_handle,'DeleteFcn',@cit_gui.CB_helperGUIclose);
            % %
            % %            set(obj.h.text_toParse,'Callback',@reference_resolver.CB_pasteRaw);
            % %            set(obj.h.button_ResetText,'Callback',@references_adder.CB_resetText);
            % %            set(obj.h.button_splitLinesByRegex,'Callback',@references_adder.CB_splitLines);
            % %            set(obj.h.check_useLiteral,'Callback',@references_adder.CB_toggleLiteral);
            % %            set(obj.h.button_EntryFinished,'Callback',@references_adder.CB_finishEntries);
            % %            set(obj.h.button_VerifyAlphaOrder,'Callback',@references_adder.CB_verifyAlphaOrder);
            % %            set(obj.h.button_verifyLength,'Callback',@references_adder.CB_verifyLength);
        end
    end
    
    %SIMPLE GUI INTERFACE METHODS ==========================================
    methods
        function clearSearchBoxes(obj)
            %clearSearchBoxes
            %
            %   clearSearchBoxes(obj)
            %
            %   NOTE: Might also add on ability via boolean to clear
            %   results ...
            
            set(obj.h.text_authorSearch,'String','')
            set(obj.h.text_yearSearch,'String','')
        end
        function changeUser(obj,user_name)
            %
            %
            %
            
            I = find(strcmp(user_name,obj.user_options),1);
            if isempty(I)
                formattedWarning('Failed to find user in options')
                return
            end
            
            set(obj.h.pm_select_user,'Value',I);
            
            obj.user_name = user_name;
            obj.client    = mendeley_client(user_name);
            updateDocTypes(obj)
        end
        function updateUserOptions(obj,user_name)
            %updateUserOptions
            %
            %   updateUserOptions(obj,user_name)
            
            obj.user_options = [obj.NULL_USER listNonHiddenFolders(obj.m_file_root)];
            set(obj.h.pm_select_user,'String',obj.user_options);
            %Should I select a user here ????
            
            if exist('user_name','var') && ~isempty(user_name)
                changeUser(obj,user_name)
            end
        end
        function year = getSearchYear(obj)
           str  = get(obj.h.text_yearSearch,'String');
           if ~isempty(str)
               year = str2double(str);
           else
               year = [];
           end
        end
        function authors = getSearchAuthors(obj)
           %
           %
           %    IMPROVEMENTS:
           %    1) Build in "" support
           
           AUTHOR_DELIMETER = ' ';
           
           author_str = get(obj.h.text_authorSearch,'String');
           authors    = stringToCellArray(author_str,AUTHOR_DELIMETER);
        end
        function type = getDocType(obj)
            %
            %   OUTPUTS
            %   ====================
            %   type : selected type, empty represents all types
            
            value = get(obj.h.pmenu_DocType,'Value');
            if value == 1
                type = '';
            else
                type = obj.user_available_doc_types{value};
            end
            
        end
        function updateDocTypes(obj)
            %
            %    Function gets all unique document types and populates menu
            %    selection handle
            %
            %
            
            all_types = [obj.ALL_DOC_TYPES_OPTION unique(obj.client.lib.docType)];
            obj.user_available_doc_types = all_types;
            set(obj.h.pmenu_DocType,'String',all_types);
            set(obj.h.pmenu_DocType,'Value',1);
        end
        function displayEntries(obj,entry_indices)
            %1) Authors
            %2) Title
            %3) Year
            %4) Published In
            %5) Doc type
            
            N_COLUMNS = 5;

            n_results = length(entry_indices);
            
            lib = obj.client.lib;
            table_data = cell(n_results,N_COLUMNS);
            
            if n_results ~= 0
                %NOTE: Might store locally which would allow sorting ...

                %NOTE: Should make this a method of lib to linearize authors ...
                table_data(:,1) = cellfun(@(x) cellArrayToString(x,' '),lib.authors(entry_indices),'un',0);
                table_data(:,2) = lib.title(entry_indices);
                table_data(:,3) = num2cell(lib.year(entry_indices));
                table_data(:,4) = lib.publication(entry_indices);
                table_data(:,5) = lib.docType(entry_indices);
            end
            
            set(obj.h.table_searchResults,'Data',table_data);
            
        end
    end
    
    %CLIENT INTERFACE METHODS
    %================================================================
    methods
        function search(obj)
           %search
           %
           %    Interface to:
           %        
           %
           %
            
            
            f_input = {'year',getSearchYear(obj),'authors',getSearchAuthors(obj),...
                'doc_type',getDocType(obj)};
            
           [matching_entry_indices,extras] = perform_search(obj.client.search_obj,f_input{:}); 
            
           displayEntries(obj,matching_entry_indices) 
        end
    end
    
    methods (Static)
        function run
            persistent g_ref
            if isempty(g_ref)
                g_ref = mendeley_client_gui;
            else
                isOpen = true;
                f = g_ref.fig_handle;
                if ~ishandle(f)
                    g_ref = mendeley_client_gui;
                    isOpen = false;
                else
                    %test if is this gui
                    name = get(f,'Name');
                    if ~strcmp(name,'mendeley_client_main')
                        g_ref = mendeley_client_gui;
                        isOpen = false;
                    end
                end
                
                if isOpen
                    figure(f)
                end
                
            end
            %Do I need to add on code here
        end
        function edit
            guide(mendeley_client_gui.getMainFigPath);
        end
        function gui_path = getMainFigPath
            class_path = getMyPath;
            fig_root   = fullfile(fileparts(class_path),'figs');
            gui_path   = fullfile(fig_root,'mendeley_client_main.fig');
        end
    end
    
    methods (Static)
        function CB_search(~,~)
           obj = getappdata(gcbf,'obj');
           search(obj) 
        end
        function CB_refreshLibrary(~,~)
            obj = getappdata(gcbf,'obj');
            obj.client.updateLibrary();
        end
        function CB_clearSearch(~,~)
           obj = getappdata(gcbf,'obj');
           clearSearchBoxes(obj) 
        end
    end
    
end

