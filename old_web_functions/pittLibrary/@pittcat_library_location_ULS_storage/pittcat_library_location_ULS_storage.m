classdef pittcat_library_location_ULS_storage < pittcat_library_location
    %pittcat_library_location_ULS_storage
    
    %openExplorerToMfileDirectory('pittcat_library_location_ULS_storage')
    
    properties
        name        = 'ULS Storage'
        full_name   = 'ULS Storage'
        physical_location = 'warehouse'
    end
    
    properties (Constant)
        is_storage  = true
        is_ULS      = true
        is_HSLS     = false
        online      = false
        type        = 'ULS Storage';
    end
    
    methods
        %See pittcat_library_location.getObject
        function obj = pittcat_library_location_ULS_storage
            
        end
    end
    
end

