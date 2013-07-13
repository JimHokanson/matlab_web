classdef textarea < html.form.element
    %
    %
    %   http://www.w3schools.com/tags/tag_textarea.asp
    %
    
    %STATUS: INCOMPLETE 
    %1) - make set method 
    
    %{
    The <textarea> tag defines a multi-line text input control.

    A text area can hold an unlimited number of characters, and the text
    renders in a fixed-width font (usually Courier).

    The size of a text area can be specified by the cols and rows
    attributes, or even better; through CSS' height and width properties.
    %}
    
    
    %   maxlength
    %   name
    %   value
    
    %Display properties
    properties
        %autofocus
        %cols
        %placeholder  %- visual hint as to what to type out
        %rows
        %wrap?????
    end
    
    properties
        %disabled
        %form
        max_length
        name
        %required
        text
    end
    
    methods
        function obj = textarea(varargin)
            obj@html.form.element(varargin{:});
            
            j = obj.jsoup_element;
            
            obj.max_length = obj.getMaxLength(j);
            
            obj.name = char(j.attr('name'));
            obj.text = char(j.text);
        end
        function prop_value_pair = getResponse(obj)
           prop_value_pair = {obj.name obj.text}; 
        end

    end
    
end

