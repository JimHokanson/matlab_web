classdef select < html.form.element
    %
    %   Class:
    %   html.form.select
    
    %{
    The <select> element is used to create a drop-down list.

    The <option> tags inside the <select> element define the available
    options in the list.
    %}
    
    
    
    %Display only properties ==========================
    properties
        %autofocus
        %size
    end
    
    %Select properties ===================================
    properties
        %disabled  NYI
        %form      NYI apply to multiple forms
        %multiple  NYI - multiple options selected at once
        name
        %required  %user is required to specify a value before
        %submitting the form ...
    end
    
    %Option properties ====================================
    properties (Constant)
       option_props = '-----  Option Properties  ------' 
    end
    
    properties
        %html.form.option
        value_array
        selected_array
        text_array
    end
    
    methods
        function obj = select(varargin)
            obj@html.form.element(varargin{:})
            
            j = obj.jsoup_element;
            
            obj.name = char(j.attr('name'));
            
            option_tags = j.select('option');
            n_elements  = option_tags.size;
            
            for iOption = 1:n_elements
                o(iOption) = html.form.option(option_tags.get(iOption-1),iOption);
            end
            
            obj.value_array    = {o.value};
            obj.selected_array = [o.selected];
            obj.text_array     = {o.text};
        end
        function selectByValue(obj,value_string)
            mask = strcmp(value_string,obj.value_array);
            
            I = find(mask);
            
            if length(I) ~= 1
                %TODO: Need to create generic error
                %sl.error.singular <- implement
                error('Singular match expected, not found')
            end
            
            obj.selected_array = mask;
            
        end
        function prop_value_pair = getResponse(obj)
           prop_value_pair = {obj.name obj.value_array{obj.selected_array}}; 
        end
    end
    
end

