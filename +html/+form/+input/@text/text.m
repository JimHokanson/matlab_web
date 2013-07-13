classdef text < html.form.input
    %
    %
    %   Class:
    %   html.form.input.text
    %
    %   text_form_element
    %   - text
    %   - password
    %   - hidden
    %
    %   Class: html.form.input.text
    
    properties
       %text
    end
    
    methods
        function obj = text(varargin)
           obj@html.form.input(varargin{:}); 
        end
    end
    
end

