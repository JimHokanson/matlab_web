classdef unhandled < html.form.input
    %
    %
    %   Class:
    %   html.form.input.unhandled

    
    properties
       true_type
    end
    
    methods
        function obj = unhandled(varargin)
           obj@html.form.input(varargin{:}); 
           
           obj.true_type = char(obj.jsoup_element.attr('type'));
           
           %TODO: 
           warning('Unandled form element type: %s',obj.true_type)
           
        end
    end
    
end

