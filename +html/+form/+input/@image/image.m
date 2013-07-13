classdef image < html.form.input
    %
    
    properties
       %formaction 
    end
    
    methods
        function obj = image(varargin)
           obj@html.form.input(varargin{:}); 
        end
%         function obj = image(jsoup_tag,order)
%            if nargin == 0
%                return
%            end
%            
%            obj.tag_order      = order; 
%            ra = html.getTagAttributes(jsoup_tag);
%            obj.raw_attributes = ra;
%         end
    end
    
end

