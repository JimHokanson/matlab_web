classdef pittcat_journal_search_result_gui < status_display
    %pittcat_journal_search_result_gui
    
    properties
        fig_handle
        h
        pcat_client

    end
    
    properties (Dependent)
        j_search_result_objs
        j_obj
        pcat_user
        client_gui %NOTE: This may or may not be defined 
    end
    
    methods
        function value = get.j_obj(obj)
           value = obj.pcat_client.j_obj;
        end
        
        function value = get.pcat_user(obj)
           value = obj.pcat_client.user_obj; 
        end
        
        function value = get.j_search_result_objs(obj)
           value = obj.pcat_client.search_obj.good_results; 
        end
        
        function value = get.client_gui(obj)
           value = obj.pcat_client.gui_obj; 
        end
    end
    
    methods (Access = private)
        function obj = pittcat_journal_search_result_gui
            
        end
    end
    
    methods (Static)
        function run(pcat_client,varargin)
            
        
            
            obj = pittcat_journal_search_result_gui;
            pittcat_notifier.init(obj)
            
            class_path = getMyPath;
            fig_root   = fullfile(fileparts(class_path),'figs');
            gui_path   = fullfile(fig_root,'pittcat_journal_search_result_gui.fig');
            
            
            
            uiopen(gui_path,1);
            obj.fig_handle = gcf;
            obj.h = guihandles(obj.fig_handle);
            obj.pcat_client = pcat_client;

            obj.status_handle = obj.h.eText_status;
            
            setappdata(obj.fig_handle,'obj',obj);
            
            %CLIENT GUI HANDLING =======================================
            if ~isempty(obj.client_gui)
                gui_h.figure.align_corners_ul(obj.client_gui.fig_handle,obj.fig_handle);
                gui_h.figure.hide(obj.client_gui.fig_handle)
                set(obj.h.button_ReturnToClient,'Callback',@pittcat_journal_search_result_gui.CB_return_to_client_gui);
                set(obj.fig_handle,'CloseRequestFcn',@pittcat_journal_search_result_gui.CB_close_figure);
            else
                set(obj.h.button_ReturnToClient,'Visible','off')
            end
            
            %OTHER CALLBACKS =============================================
            set(obj.h.button_requestJournalArticle,'Callback',@pittcat_journal_search_result_gui.CB_requestArticle);
            set(obj.h.button_requestViaILL,'Callback',@pittcat_journal_search_result_gui.CB_request_article_via_ILL);
            set(obj.h.button_debug,'Callback',@pittcat_journal_search_result_gui.CB_debug);
            
            %JAH TODO: Need method to determine if ILL is ok or not
            
            %is_ILL_recommended(pcat_user)
            
            %JAH TODO: Handle the case when there are no matches present ...
            
            
            set(obj.h.eText_goalVolume,'String',obj.j_obj.volume);
            set(obj.h.eText_goalYear,'String',obj.j_obj.year);
            set(obj.h.eText_goalISSN,'String',obj.j_obj.issn);
            
            
            if ~isempty(obj.j_search_result_objs)
                data = getTableDisplay(obj.j_search_result_objs);
                set(obj.h.table_Results,'Data',data);
            else
                %Crap, move to having classes ...
                %These don't exactly gray out .......
                gui_h.button.set_enable_inactive(obj.h.button_requestJournalArticle);
                gui_h.generic_control.set_enable_inactive(obj.h.table_Results);
            end
            
            
            
        end
        
        function CB_request_article_via_ILL(~,~)
            obj = getappdata(gcbf,'obj');
            [success,extras] = pittcat_web_interface.request_via_ILL(obj.j_obj,obj.pcat_user);
        end
        
        function CB_close_figure(~,~)
            obj = getappdata(gcbf,'obj');
            delete(obj.fig_handle)
            if ~isempty(obj.client_gui)
               delete(obj.client_gui.fig_handle) 
            end
        end
        
        function CB_return_to_client_gui(~,~)
            obj = getappdata(gcbf,'obj');
            gui_h.figure.align_corners_ul(obj.fig_handle,obj.client_gui.fig_handle);
            set(obj.client_gui.fig_handle,'Visible','on')
            delete(obj.fig_handle)
            pittcat_notifier.init(obj.client_gui)
        end
        
        function CB_requestArticle(~,~)
            %Call request on selected object
            
            obj = getappdata(gcbf,'obj');
            index = gui_h.edit_text.get_number(obj.h.eText_NumberRequest);
            
            if ~isnan(index)
                if index > 0 && index <= length(obj.j_search_result_objs)
                    request(obj.j_search_result_objs(index));
                else
                    %JAH TODO: Change this ...
                    formattedWarning('Invalid request index')
                end
            end
        end
        
        function CB_debug(~,~)
            obj = getappdata(gcbf,'obj');
            disp(createLinkForCommands('Open to debug line','goDebug'))
            keyboard
        end
        
    end
    
end

