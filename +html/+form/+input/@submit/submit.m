classdef submit < html.form.input
    %
    
    properties
        
    end
    
    methods
        function obj = submit(varargin)
            obj@html.form.input(varargin{:});
        end
        %         function obj = submit(jsoup_tag,order)
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

