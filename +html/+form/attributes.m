classdef attributes < sl.obj.handle_light
    %
    
    
    %Not handled
    %------------------------------
    %{
    accept
    accept-charset
    autocomplete
    novalidate
    target
    
    
    %}
    
    
    properties
        action   %char, Absolute URL
        encoding_type = 'application/x-www-form-urlencoded'
        method        = 'GET'
        name %HTML
        id   %XHTML
    end
    
    properties
       form_element 
    end
    
    methods
        function obj = attributes(cur_form_element)
           obj.form_element = cur_form_element;
           
           obj.action       = char(cur_form_element.attr('abs:action'));
           
           method_local = char(cur_form_element.attr('method'));
           if ~isempty(method_local)
              obj.method = method_local; 
           end
           
           enctype = char(cur_form_element.attr('enctype'));
           if ~isempty(enctype)
              obj.encoding_type = enctype; 
           end
           
           obj.name = char(cur_form_element.attr('name'));
           obj.id   = char(cur_form_element.attr('id'));
           
           %obj.raw_attributes = html.getTagAttributes(form_obj); 
        end
    end
    
end

