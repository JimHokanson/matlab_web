classdef file < html.form.input
    %
    
    properties
        
    end
    
    methods
        function obj = file(varargin)
            obj@html.form.input(varargin{:});
        end
        %         function obj = file(jsoup_tag,order)
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

