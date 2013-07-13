classdef element < matlab.mixin.Heterogeneous & sl.obj.handle_light
    %
    %
    %   Class:
    %   html.form.element
    %
    
    properties (Constant)
        element_props = '------ html.form.element props ----'
    end
    
    properties
        jsoup_element
        attributes
        object_order
    end
    
    methods
        function value = get.attributes(obj)
            %Lazy evaluation ...
            if isempty(obj.attributes)
                obj.attributes = html.getTagAttributes(obj.jsoup_element);
            end
            value = obj.attributes;
        end
    end
    
    methods
        function obj = element(jsoup_element,object_order)
            obj.jsoup_element = jsoup_element;
            obj.object_order  = object_order;
        end
        function prop_value_pair = getResponse(~)
            prop_value_pair = {};
        end
        function summarize(obj)
           %Todo: implement in each subclass based on important props 
           fprintf(1,'%s\n',char(obj.jsoup_element.toString));
        end
    end
    
    methods (Hidden)
        %I don't like this being here, should move somewhere else
        function setTextValue(obj,new_value)
           if new_value > obj.max_length
               obj.text = new_value(1:obj.max_length);
           else
               obj.text = new_value;
           end
        end 
    end
    
    methods (Static,Hidden)
        function max_length = getMaxLength(jsoup_element)
            %
            %   max_length = html.form.s.getMaxLength(jsoup_element)
            
            temp = char(jsoup_element.attr('maxlength'));
            if isempty(temp)
                max_length = Inf;
            else
                max_length = str2double(temp);
            end
        end
    end
    
end

