classdef checkbox < html.form.input
    %
    %
    %   Class: html.form.input.checkbox
    %
    %   Object is singular but properties are arrays
    
    
    %Properties to Handle
    %------------------------------------------
    %- checked
    %
    
    
    properties 
       checked
    end
    
    methods
        function obj = checkbox(varargin)
           obj@html.form.input(varargin{:}); 
        end
%         function obj = checkbox(obj_order_I,raw_attributes)
%            if nargin == 0
%                return
%            end
%            
%            obj.tag_order      = obj_order_I; 
%            obj.raw_attributes = raw_attributes;
%            
%            nObjs = length(raw_attributes);
%            obj.names  = cell(1,nObjs);
%            obj.values = cell(1,nObjs);
%            obj.is_checked = false(1,nObjs);
%            for iObj = 1:nObjs
%               cur_a = raw_attributes{iObj};
%               obj.names{iObj}      = cur_a.name;
%               obj.values{iObj}     = cur_a.value;
%               obj.is_checked(iObj) = isfield(cur_a,'checked'); 
%            end
%            
%         end
%         function setCheckBox(obj,name_or_index,status)
%            %
%            %    TODO: Add documentation    
%            %
%            if isnumeric(name_or_index)
%               index_use = name_or_index;
%                if index_use < 1 || index_use > length(obj.names)
%                   error('Specified index value: %d, is out of range: %d',index_use,length(obj.names)) 
%                end
%            elseif ischar(name_or_index)
%               name_use  = name_or_index;
%               index_use = find(strcmp({obj.names},name_use));
%               if length(index_use) ~= 1
%                 error('Unable to find singular match for specified name: %s',name_use);
%               end
%            else
%                error('Input type must be numeric or string')
%            end
%            obj.is_checked(index_use) = status;
%         end
    end
    
end

