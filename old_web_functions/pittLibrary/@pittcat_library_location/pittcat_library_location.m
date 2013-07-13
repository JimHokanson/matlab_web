classdef pittcat_library_location < handle
    %pittcat_library_location
    %
    %   Implemented By:
    %   =========================================
    %   pittcat_library_location_ULS_storage
    %   pittcat_library_location_HSLS_storage
    %   pittcat_library_location_ULS_Library
    %   pittcat_library_location_HSLS_Library
    %   pittcat_library_location_Online

    
    properties (Abstract)
        physical_location
        name
        full_name
    end
        
    properties (Abstract,Constant)
        is_storage
        is_ULS
        is_HSLS
        online
        type  
    end
    
    properties
        raw_text
        parent      %(class pittcat_library_holding)
    end
    
    properties (Dependent)
       result_page  %(class pittcat_result_page)
    end
    
    methods
        function value = get.result_page(obj)
           value = obj.parent.parent;
        end
    end
    
    properties (Constant, Hidden)
       KNOWN_TYPES = {'ULS Storage','HSLS Storage','ULS Library','HSLS Library','Online'}; 
    end
    
    methods (Abstract)
       [success,extras] = request_journal_article(obj,pittcat_client_obj,j_obj) 
    end
    
    methods (Static)

        function obj = getObject(raw_text,holding)
            %Created by 
            
            %JAH TODO: Fix this approach
            %I need to instantiate derived classes, but they should only be
            %instantiated from this method (private won't work)
            
            switch raw_text
                case 'ULS Storage'
                    obj = pittcat_library_location_ULS_storage;
                case 'Falk Library Closed Stacks - Ask at Main Desk'
                    obj = pittcat_library_location_HSLS_Library('Falk Library Closed Stacks',raw_text,'Falk Library');
                case 'Falk Library - Periodicals - 200 Scaife Hall'
                    obj = pittcat_library_location_HSLS_Library('Falk Library - Periodicals',raw_text,'Falk Library');
                case 'HSLS Storage - Request via HSLS Service Requests'
                    obj = pittcat_library_location_HSLS_storage;
                case 'Available Online'
                    obj = pittcat_library_location_Online;
                case 'Langley Library (217 Langley Hall) Serials Non-circ'
                    obj = pittcat_library_location_ULS_Library('Langeley Serials Non-Circ',raw_text,'Langley Library');
                case 'Hillman Journals (4th Fl.1970+; Gr. Fl. pre-1970) (Non-circ)'
                    obj = pittcat_library_location_ULS_Library('Hillman Journals Non-Circ',raw_text,'Hillman Library');
                otherwise
                    fprintf(2,'Unrecognized Library: %s\n',raw_text);
                    fprintf(2,'Please add to class: pittcat_library_location\n');
                    error('Add library to switch statement ...')
            end 
            
            obj.raw_text = raw_text;
            obj.parent   = holding;
            
        end
    end
    
end

