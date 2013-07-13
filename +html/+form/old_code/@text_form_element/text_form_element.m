classdef text_form_element < html.form.form_element
    %
    %
    %   Class: html.form.text_form_element
    %
    %
    %   OLD CODE
    
% % % %     properties
% % % %        names       %cellstr
% % % %        max_length  %numeric array, NaN means no limit 
% % % %        values      %cellstr
% % % %     end
% % % %     
% % % %     methods
% % % %         function fillProperties(obj,obj_order_I,raw_attributes)
% % % %            obj.tag_order      = obj_order_I;
% % % %            obj.raw_attributes = raw_attributes;
% % % %            
% % % %            nObjs      = length(obj_order_I);
% % % %            obj.names  = getFieldFromCellArray(raw_attributes,'name',false);
% % % %            obj.values = getFieldFromCellArray(raw_attributes,'value',false);
% % % %            obj.max_length = cell(1,nObjs);
% % % %            for iObj = 1:nObjs
% % % %                cur_attributes = raw_attributes{iObj};
% % % %                if isfield(cur_attributes,'maxlength')
% % % %                   obj.max_length{iObj} = str2double(cur_attributes.maxlength);
% % % %                else
% % % %                   obj.max_length{iObj} = NaN;
% % % %                end
% % % %            end
% % % %         end
% % % %         function match_found = setTextValue(obj,name,value)
% % % %            
% % % %             name_index = find(strcmp(obj.names,name));
% % % %             %TODO: error check
% % % %             if isempty(name_index)
% % % %                 match_found = false;
% % % %                 return
% % % %             else
% % % %                 match_found = true;
% % % %             end
% % % %             
% % % %             max_length_local = obj.max_length(name_index);
% % % %             if ~isnan(max_length_local) && length(value) > max_length_local
% % % %                 obj.values{name_index} = value(1:max_length_local);
% % % %             else
% % % %                 obj.vlaues{name_index} = value;
% % % %             end
% % % %             
% % % %         end
% % % %     end
% % % %     
end

