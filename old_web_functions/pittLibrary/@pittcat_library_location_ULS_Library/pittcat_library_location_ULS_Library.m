classdef pittcat_library_location_ULS_Library < pittcat_library_location
    
      properties
        name     
        full_name
        physical_location
    end
    
    properties (Constant)
        is_storage  = false
        is_ULS      = true
        is_HSLS     = false
        online      = false
        type        = 'ULS Library';
    end
    
    methods
        %See pittcat_library_location.getObject
        function obj = pittcat_library_location_ULS_Library(name,full_name,physical_location)
           obj.name = name;
           obj.full_name = full_name;
           obj.physical_location = physical_location;
        end
    end  
    
end