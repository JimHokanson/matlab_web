classdef pittcat_client_gui < status_display
    %pittcat_client_gui
    %
    %   CALL VIA: pittcat_client_gui.run
    
    properties
        %NOTE: These two should be abstract
        fig_handle
        h
        client
        
    end

    methods (Access = private)
        function obj = pittcat_client_gui
            
           pittcat_notifier.init(obj)
           gui_path   = pittcat_client_gui.getMainFigPath; 
            
           uiopen(gui_path,1);
           obj.fig_handle = gcf;
           obj.h = guihandles(obj.fig_handle);
           setappdata(obj.fig_handle,'obj',obj);
           
           obj.status_handle = obj.h.eText_status;
           
           set(obj.h.button_bibtexClipboard,'Callback',@pittcat_client_gui.CB_getDocStructFromBibtex);
           set(obj.h.button_getDocStructFromPMID,'Callback',@pittcat_client_gui.CB_getDocStructFromPMID);
           set(obj.h.button_searchPittcat,'Callback',@pittcat_client_gui.CB_search_pittcat);
           set(obj.h.button_debug,'Callback',@pittcat_client_gui.CB_debug);  
        end
        function updateDocDisplayTable(obj)
           %Get data from journal object
           data = getDisplayTable(obj.client.j_obj);
           str  = cellMatrixToString(data,'col_delim',': ');
           set(obj.h.text_docStruct,'String',str);
        end
        function init(obj,varargin)
           
           in.prev_client = [];
           in = processVarargin(in,varargin);
            
           if isempty(in.prev_client)
               
              if ~isobject(obj.client) 
                  obj.client = pittcat_client('gui_obj',obj,'verbose',true);
              else
                  
              end
           else
              obj.client = in.prev_client;
              setGUIobj(obj.client,obj)
              updateDocDisplayTable(obj)
           end

        end
        
    end
    
    methods (Hidden, Static)
        
        function CB_debug(~,~)
           obj = getappdata(gcbf,'obj');
         
           disp(createLinkForCommands('Open to debug line','goDebug'))
           keyboard
           
        end
        function CB_getDocStructFromPMID(~,~)
           obj  = getappdata(gcbf,'obj');
           pmid = get(obj.h.text_pmid,'String');
           populateDocFromPMID(obj.client,pmid)
           updateDocDisplayTable(obj)
        end 
        function CB_getDocStructFromBibtex(~,~)
           obj  = getappdata(gcbf,'obj');
           populateDocFromBibtex(obj.client)
           updateDocDisplayTable(obj)
        end 
        function CB_search_pittcat(~,~)
           obj  = getappdata(gcbf,'obj');
           search(obj.client,'show_GUI',true)
        end
        function CB_view_user_details(~,~)
           obj  = getappdata(gcbf,'obj');
           error('Not yet implemented')
        end
        %NOTE: Should inherit this from some function
        %i.e. should just be
        %function self_ref
        %   self_ref@gui_helper(name)
        %end
        
        function ref = self_ref

           %ASSUMPTIONS fig_handle exists ... 
            
           persistent g_ref GUI_NAME
           
            if isempty(g_ref)
                g_ref    = pittcat_client_gui;
                f        = g_ref.fig_handle;
                GUI_NAME = get(f,'Name');
            else
                %NOTE: Should I test for property ????
                f = g_ref.fig_handle;
                if ~ishandle(f)
                    g_ref = pittcat_client_gui;
                else
                   %test if is this gui 
                   name = get(f,'Name');
                   if ~strcmp(name,GUI_NAME)
                    g_ref = pittcat_client_gui;
                   end
                end
            end 
            ref = g_ref;
        end
        
        
    end
    
    methods (Static)
        function debug
           ref = pittcat_client_gui.self_ref;
           disp(createLinkForCommands('Open to debug line','goDebug'))
           keyboard 
        end
        
        function run(client_obj)
         %
         %  run(*client_obj)
         
            if ~exist('client_obj','var')
               client_obj = []; 
            end
            obj = pittcat_client_gui.self_ref;
            figure(obj.fig_handle)
           
           
            init(obj,'prev_client',client_obj)
           
           
        end
        
        function edit
           guide(pittcat_client_gui.getMainFigPath)
        end
        
        %NOTE: This should be an abstract method
        function gui_path = getMainFigPath
            class_path = getMyPath;
            fig_root   = fullfile(fileparts(class_path),'figs');
            gui_path   = fullfile(fig_root,'pittcat_client_gui.fig'); 
        end
    end
    
end

