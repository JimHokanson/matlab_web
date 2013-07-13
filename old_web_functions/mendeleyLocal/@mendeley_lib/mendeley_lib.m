classdef mendeley_lib < handle
    %mendeley_lib
    %
    %NOTE: I really dislike this code but I think it works so far
    %
   
    
    %PROBLEMS
    %-----------------------------------------------------
    %1) What to do on updates
    %2) Displaying all properties of a single entry - perhaps a GUI is needed
    %3)
    
    %METHODS IN OTHER FILES
    %===========================================
    %   readLibraryFromDisk
    %   updateDocIDsUser
    %   writeLibraryToDisk
    %   parseEntries
    
    
    %FOR PROPERTY UPDATES
    %===========================================
    %1) See writeLibraryToDisk
    %2) 
    
    properties (Constant, Hidden)
        NOT_VARS = {'VERSION' 'client_obj' 'NOT_VARS'};
        ENTRY_SIZED_VARIABLES = {'entries' 'ids' 'lastRead' 'created' 'title'...
            'authors' 'year' 'publication' 'docType'}
    end
    
    properties
        VERSION = 3.2;
        client_obj  %(Class mendeley_client), generally this is a parent
        search_obj  %(Class mendeley.lib.search)
        
        entries     %(cell array, raw data from Mendeley)
        ids         %(numeric array, BIG ASSUMPTION, IDs are small enough to be represented accurately with doubles)
        lastRead    %(Matlab date) date last queried from Mendeley
        created     %(Matlab date) date first appeared in Mendeley
        
        title
        authors     %(string, all authors last names concatenated with spaces
        year
        publication
        docType
        
        last_id_check
    end
    
    properties (Dependent)
       n_entries 
    end
    
    methods
        function value = get.n_entries(obj)
           value = length(obj.entries);
        end
    end
    
    methods
        getLibrary(obj,varargin)
        initLibStruct(obj,nEntries)
%         function methods(obj)
%            NOT YET IMPLEMENTED 
%         end
    end
    
    methods
        function obj = mendeley_lib(client_obj)
            obj.client_obj = client_obj;
            obj.search_obj = mendeley.lib.search(obj);
            
            getLibrary(obj);
        end
    end
    
end

