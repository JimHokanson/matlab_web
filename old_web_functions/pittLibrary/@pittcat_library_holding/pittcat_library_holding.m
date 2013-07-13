classdef pittcat_library_holding < handle
    %pittcat_library_holding
    %
    
    properties
        parent    %(derived class of pittcat_result_page)
        location  %(derived class of pittcat_library_location)
    end
    
    properties
       raw   %raw structure before any processing
       %     fields with .name and .values (cellstr)
    end
    
    properties (Dependent)
       rawString
%        get_it_link
    end
    
    methods
%         function value = get.get_it_link(obj)
%            value = obj.parent.get_it_link; 
%         end
        
        function value = get.rawString(obj)
           if isempty(obj.raw)
               value = [];
           else
              str = [];
              fn = fieldnames(obj.raw);
              for iField = 1:length(fn)
                  curField = fn{iField};
                  
                  if isstruct(obj.raw.(curField))
                      str = sprintf('%s %s:\n',str,obj.raw.(curField).name);
                      values = obj.raw.(curField).values;
                      for iValue = 1:length(values)
                         str = sprintf('%s\t %s\n',str,values{iValue}); 
                      end
                  end
              end
              value = str;
           end
        end
    end
    
    
    methods (Hidden)
        function initObject(obj,pittcat_result_page,holding_struct)
           obj.parent   = pittcat_result_page;
           obj.location = pittcat_library_location.getObject(holding_struct.Location.values{1},obj);
           obj.raw      = holding_struct; 
        end
    end
    
end

