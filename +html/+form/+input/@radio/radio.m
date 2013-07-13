classdef radio < html.form.input
    %
    %
    %   radio:
    %   ===================================================================
    %   radio objects need to be grouped by name
    %
    %   After creation, form groups ...
    %
    %   http://www.w3schools.com/html/tryit.asp?filename=tryhtml_radio
    
    properties
        checked  %logical array
    end
    
    methods
        function obj = radio(varargin)
           obj@html.form.input(varargin{:}); 
           
           j = obj.jsoup_element;
           obj.checked = ~isempty(char(j.attr('checked')));
           
        end
        
% % %         function objs = radio_group(order_I,names,attributes)
% % %            if nargin == 0
% % %                return
% % %            end
% % %            
% % %            [uNames,uIndices] = unique2(names);
% % %            nGroups = length(uNames);
% % %            objs(nGroups) = html.form.input.radio_group;
% % %            for iGroup = 1:nGroups
% % %               cur_indices    = uIndices{iGroup};
% % %               cur_attributes = attributes(cur_indices);
% % %               objs(iGroup).name      = uNames{iGroup};
% % %               objs(iGroup).values    = getFieldFromCellArray(cur_attributes,'value',false);
% % %               objs(iGroup).tag_order = order_I(cur_indices);
% % %               objs(iGroup).checked   = cellfun(@(x) isfield(x,'checked'),cur_attributes);
% % %            end
% % %         end
% % %         function selectRadioButton(objs,group_name_or_index,value_in_group_or_index)
% % %            %
% % %            %
% % %            %
% % %            
% % %            if isempty(objs)
% % %               error('Radio Groups are empty, function shouldn''t be called, no buttons to select') 
% % %            end
% % %            
% % %            %Step 1, transfer name to index - name indicates group
% % %            %---------------------------------------------------------------
% % %            if isnumeric(group_name_or_index)
% % %                group_name_index = group_name_or_index;
% % %                if group_name_index < 1 || group_name_index > length(objs)
% % %                   error('Specified index value: %d, is out of range: %d',group_name_index,length(objs)) 
% % %                end
% % %            else
% % %                name_to_match = group_name_or_index; 
% % %                group_name_index = find(strcmp(name_to_match,{objs.name}));
% % %                if length(group_name_index) ~= 1
% % %                    error('Unable to find singular match for specified radio group name: %s',name_to_match);
% % %                end
% % %            end
% % %             
% % %            cur_obj = objs(group_name_index);
% % %            
% % %            %Step 2, transfer value to index - value indicates which
% % %            %---------------------------------------------------------------
% % %            if isnumeric(value_in_group_or_index)
% % %                group_value_index = value_in_group_or_index;
% % %                if group_value_index < 1 || group_value_index > length(cur_obj.values)
% % %                   error('Specified index value: %d, is out of range: %d',group_value_index,length(cur_obj.values)) 
% % %                end
% % %            else
% % %                value_to_match = value_in_group_or_index;
% % %                group_value_index = find(strcmp({cur_obj.values},value_to_match));
% % %                if length(group_value_index) ~= 1
% % %                   error('Unable to find singular match for specified radio group value: %s',value_to_match); 
% % %                end
% % %            end
% % %            
% % %            cur_obj.checked(:) = false;
% % %            cur_obj.checked(group_value_index) = true;
% % %         end
    end
    
end

