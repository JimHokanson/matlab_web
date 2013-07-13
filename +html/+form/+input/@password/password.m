classdef password < html.form.input
    %
    %   NOTE: password takes on an array format
    %   in its properties. The class itself is singular.
    %   
    
    properties
       text
    end
    
    methods
        function obj = password(varargin)
           obj@html.form.input(varargin{:}); 
        end
%         function obj = password(obj_order_I,raw_attributes)
%            if nargin == 0
%                return
%            end
%            
%            %Method of html.form.text_form_element
%            %method: html.form.text_form_element.fillProperties
%            fillProperties(obj,obj_order_I,raw_attributes);
%         end
    end
    
end

