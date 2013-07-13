classdef pittcat_library_location_Online < pittcat_library_location
    %pittcat_library_location_Online
    
    properties
        name        = 'Online'
        full_name   = 'Online'
        physical_location = 'in the cloud'
    end
    
    properties (Constant)
        is_storage  = false
        is_ULS      = false
        is_HSLS     = false
        online      = true
        type        = 'Online';
    end
    
    methods (Access = private)
        %See pittcat_library_location.getObject
        function obj = pittcat_library_location_Online
            
        end
    end
    
end