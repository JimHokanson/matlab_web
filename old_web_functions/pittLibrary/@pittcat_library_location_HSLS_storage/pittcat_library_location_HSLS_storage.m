classdef pittcat_library_location_HSLS_storage < pittcat_library_location
    %pittcat_library_location_HSLS_storage
    
    properties
        name        = 'HSLS Storage'
        full_name   = 'HSLS Storage'
        physical_location = 'warehouse'
    end
    
    properties (Constant)
        is_storage  = true
        is_ULS      = false
        is_HSLS     = true
        online      = false
        type        = 'HSLS Storage';
    end
    
    methods
        %See pittcat_library_location.getObject
        function obj = pittcat_library_location_HSLS_storage
            
        end
    end
    
end
