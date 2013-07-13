classdef form < sl.obj.handle_light
    %
    %
    %   Class:
    %   html.form
    %
    %   http://www.w3schools.com/tags/tag_form.asp
    %
    
    %   EXTERNAL METHODS
    %   ===================================================================
    
    
    
    %{
    
    OUTLINE:
    1) Build initial object
    2) 
    
    
    
    
    %}
    
    
    properties
        attributes

    end
    
    %MAIN PROPERTY TAGS
    %======================================================================
    properties
        all_elements %cell array
        
        input_tags     %Class: html.form.input.?
        textarea_tags  %Class: html.form.textarea
        button_tags    %Class: html.from.button
        select    %Class: html.form.select , multiple objects
        
        %option_tags    %Located in the select tags
        %optgroup_tags  %Not currently used, would go in select tags if it
        %were implemented
        
        fieldset_tags  %
        label          %Class: html.form.label
        
        text_objects
        
        %text_objects - text_area, input_password, input_
        %radio_buttons
        
    end
    
    methods (Access = private)
        function obj = form(all_form_elements,b1_index)
            %
            %   objs = form(form_tag_ref,b1_index)
            %
            %   Call the constructor with:
            %   html.form.create
            %
            %   INPUTS
            %   ===========================================================
            %   all_form_elements : Class: org.jsoup.select.Elements
            %   b1_index          : which element to examine, base 1

                cur_form_element = all_form_elements.get(b1_index - 1);
            
                obj.attributes = html.form.attributes(cur_form_element);
            
                %html.form.parse
                obj.parse(cur_form_element);
        end
    end
    
    %PUBLIC METHODS
    %1) select check box
    %2) select radio
    %3) set text value
    %4) 
    methods
        function summary(obj)
           e_local = obj.all_elements; 
           n_elements =  length(e_local);
           for iLocal = 1:n_elements
              cur_element = e_local{iLocal};
              cur_element.summarize;
           end
        end
    end
    
    methods (Static)
        function objs = create(varargin)
            %create Creates the form objects ...
            %
            %   CALLING FORMS
            %   =======================================
            %   objs = html.form.create(web_url)
            %
            %   objs = html.form.create(web_text,previous_url);
            %
            %   objs = html.form.create(jsoup_document);
            
            if nargin == 1
                if isjava(varargin{1})
                    d = varargin{1};
                    %TODO: Check class
                else
                    web_url = varargin{1};
                    d       = jsoup.getDoc(web_url);
                end
            elseif nargin == 2
                web_text = varargin{1};
                prev_url = varargin{2};
                d        = jsoup.getDoc(web_text,prev_url);
            else
                error('Unexpected # of input arguments')
            end
            
            %FORM INITIALIZATION
            %============================================
            b         = d.body;
            form_tags = b.getElementsByTag('form');
            nForms    = form_tags.size;
            
            if nForms == 0
                objs = html.form.empty(0,1);
                return
            end
            
            for iObj = 1:nForms
                objs(iObj) = html.form(form_tags,iObj); %#ok<AGROW>
            end           
        end
    end
    
    methods (Access = private,Hidden)
        parse(obj,form_obj)
    end
    
    methods
        function getRequestObject
        end
    end
    
    %PROPERTY SETTING METHODS
    %======================================================================
%     methods
%         function p_selectOption(obj,name_or_index,selection_method,selection_value)
%             selectOption(obj.select_tags,name_or_index,selection_method,selection_value)
%         end
%         function p_selectRadioButton(obj,name_or_index,value_or_index)
%             %
%             %TODO: Provide documentation here ...
%             selectRadioButton(obj.input_radio_groups,name_or_index,value_or_index)
%         end
%         function p_setCheckBox(obj,name_or_index,status)
%             %
%             %TODO: Provide documentation here ...
%             if nargin == 2
%                 status = true;
%             end
%             setCheckBox(obj.input_checkbox_tags,name_or_index,status)
%         end
%         function p_setTextValue(obj,name,value)
%             
%             %1) text inputs
%             
%             %2) passwords
%             
%             %3) hidden
%             
%             %4) textarea
%             
%         end
%     end
    
end

