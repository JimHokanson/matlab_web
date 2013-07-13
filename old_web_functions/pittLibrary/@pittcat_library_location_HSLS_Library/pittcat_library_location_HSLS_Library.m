classdef pittcat_library_location_HSLS_Library < pittcat_library_location
    %pittcat_library_location_HSLS_Library
    
    properties
        name     
        full_name
        physical_location
    end
    
    properties (Constant)
        is_storage  = false
        is_ULS      = false
        is_HSLS     = true
        online      = false
        type        = 'HSLS Library';
    end
    
    methods
        %See pittcat_library_location.getObject
        function obj = pittcat_library_location_HSLS_Library(name,full_name,physical_location)
           obj.name = name;
           obj.full_name = full_name;
           obj.physical_location = physical_location;
        end
    end
    
end

