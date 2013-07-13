classdef option < html.form.element
    %
    %
    %   Class:
    %   html.form.option
    %
    %   http://www.w3schools.com/tags/tag_option.asp
    %
    %   
    
    properties
       %disabled - Not yet suppported
       %label - ???
       %selected - 
       %value
       value    %Value to send to server
       selected %
       text     %Option displayed to user ...
    end
    
    methods
        function obj = option(varargin)
           obj@html.form.element(varargin{:})
           
           j = obj.jsoup_element;
           
           obj.value    = char(j.attr('value'));
           obj.text     = char(j.text);
           obj.selected = ~isempty(char(j.attr('selected')));
        end
        function prop_value_pair = getResponse(obj)
           prop_value_pair = {}; 
        end
        
        
        
        
        
        
% % % %         function obj = select(jsoup_select_tag,order)
% % % %             if nargin == 0
% % % %                 return
% % % %             end
% % % %             
% % % %             obj.tag_order      = order;
% % % %             obj.raw_attributes = html.getTagAttributes(jsoup_select_tag);
% % % %             obj.name           = obj.raw_attributes.name;
% % % %             
% % % %             option_tags = jsoup_select_tag.getElementsByTag('option');
% % % %             nOptions    = option_tags.size;
% % % %             
% % % %             %Initialize props
% % % %             %------------------------------------------------------
% % % %             obj.options_attributes = cell(1,nOptions);
% % % %             obj.options_data       = cell(1,nOptions);
% % % %             obj.options_values     = cell(1,nOptions);
% % % %             obj.options_selected   = false(1,nOptions);
% % % %             
% % % %             for iOption = nOptions:-1:1
% % % %                 cur_option_tag = html.form.option(option_tags.get(iOption-1));
% % % %                 cur_attributes                  = html.getTagAttributes(cur_option_tag);
% % % %                 obj.options_attributes{iOption} = cur_attributes;
% % % %                 obj.options_data{iOption}       = char(cur_option_tag.text);
% % % %                 if isfield(cur_attributes,'value')
% % % %                     obj.options_values{iOption} = cur_attributes.value;
% % % %                 else
% % % %                     obj.options_values{iOption} = obj.options_data{iOption};
% % % %                 end
% % % %                 obj.options_selected(iOption)   = isfield(cur_attributes,'selected');
% % % %             end
% % % %             if ~any(obj.options_selected)
% % % %                 obj.options_selected(1) = true;
% % % %             end
% % % % 
% % % %         end
% % % %         function selectOption(objs,name_or_index,selection_method,selection_value)
% % % %             
% % % %            %1) Determine object
% % % %            %--------------------------------------------------
% % % %            if isnumeric(name_or_index)
% % % %                obj_index = name_or_index;
% % % %                %TODO: error check range
% % % %            elseif ichar(name_or_index)
% % % %                name_use = name_or_index;
% % % %                obj_index = find(strcmp({objs.name},name_use));
% % % %                if length(obj_index) ~= 1
% % % %                    error('Unable to find singular match for select tag with name: %s',name_use)
% % % %                end
% % % %            else
% % % %                error('Input not recognized')
% % % %            end
% % % %            
% % % %            cur_obj = objs(obj_index);
% % % %            
% % % %            %2) Determine option index
% % % %            switch selection_method
% % % %                 case 'index'
% % % %                     option_index = selection_value;
% % % %                 case 'value'
% % % %                     option_index = find(strcmp(cur_obj.options_values,selection_value));
% % % %                     %TODO: error check
% % % %                 case 'data'
% % % %                     option_index = find(strcmp(cur_obj.options_data,selection_value));
% % % %                     %TODO: error check
% % % %                 otherwise
% % % %                     error('Invalid selectMethod option')
% % % %            end 
% % % %             
% % % %            %3) Make selection
% % % %            cur_obj.options_selected(:)            = false;
% % % %            cur_obj.options_selected(option_index) = true;
% % % %         end
    end
    
end

