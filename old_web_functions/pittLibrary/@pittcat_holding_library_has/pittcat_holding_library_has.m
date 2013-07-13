classdef pittcat_holding_library_has < handle
    %pittcat_holding_library_has
    %
    %   Object to describe the "Library Has:" line in the holdings ...
    
    %FUNCTIONS IN OTHER FILES
    %======================================
    %populateProperties
    %checkVolumeAndYear
    
    properties
        vol_numbers
        year_numbers
        raw_text
        init_regex
        dropped_text = ''
        has_partial_volume_info = false
        has_partial_year_info   = false
        skipped = false
    end
    
    properties (Dependent)
       was_filtered
       is_special   %For display in search results to consider whether or not to request ...
    end
    
    properties
        parent
    end
    
    methods
        function value = get.was_filtered(obj)
           value = ~isempty(obj.dropped_text);
        end
        
        function value = get.is_special(obj)
           value = obj.has_partial_volume_info || obj.has_partial_year_info || obj.was_filtered;
        end
    end
    
    methods
        function obj = pittcat_holding_library_has(raw_text_lines,holding_obj)
            if nargin == 0
                return
            end
            
            nObjs = length(raw_text_lines);
            obj(nObjs) = pittcat_holding_library_has;
            for iObj = 1:nObjs
               obj(iObj).raw_text = raw_text_lines{iObj};
               obj(iObj).parent   = holding_obj;
               populateProperties(obj(iObj))
            end
        end
    end
    
end

