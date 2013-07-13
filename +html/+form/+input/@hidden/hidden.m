classdef hidden < html.form.input
    %
    %
    %   Class: html.form.input.hidden
    
    properties
       text 
    end
    
    methods
        function obj = hidden(varargin)
           obj@html.form.input(varargin{:}); 
        end
%         function obj = hidden(obj_order_I,raw_attributes)
%            if nargin == 0
%                return
%            end
%            
%            fillProperties(obj,obj_order_I,raw_attributes);
%         end
    end
    
end

