classdef mendeley_client < handle
%mendeley_client Client for performing functions with Mendeley
%
%
%   See Also:
%       menedeley_lib %Main class for holding library documents ...
%       
%
%
%   CURRENT PROBLEMS
%   ------------------------------------------------
%   - performing search
%   - interfacing with the public and private methods of Mendeley
%   - creating a new user
%   - 

    %FILES
    %-------------------------------------------
    %library file - 
    
    %METHODS IN OTHER FILES
    %==================================================
    %populateAuthStruct
    %populatePaths
    
    properties
        user_name = '' 
        auth_struct % (structure), for making Mendeley API requests
                    %   .consumer_key
                    %   .consumer_secret
                    %   .oauth_access_token
                    %   .oauth_access_token_secret
        lib         % (Class mendeley_lib)
    end

    properties (Dependent)
       search_obj   % (Class mendeley.lib.search)
       %NOTE: I'm not sure where I want this to be yet ...
    end
    
    methods 
        function value = get.search_obj(obj)
           value = obj.lib.search_obj; 
        end
    end
    
    properties
       user_root_path       %
       user_creds_path      %
       api_creds_path       %Path to API account information
       user_docIDs_path     %Path to .mat that contains info about document ids
       user_libMat_path
       user_test_path
    end
    
    properties 
        M_FILE_ROOT = ''
    end
    
    methods
        populateAuthStruct(obj,isPublic)
        populatePaths(obj,test_user_name) 
    end
    
    methods  
        function updateLibrary(obj)
           %Simple wrapper for mendeley_lib.getLibrary
           %
           %    Updates library, only getting new info
           
           obj.lib.getLibrary('OPTION',1); 
        end
        
        
        function value = get.M_FILE_ROOT(obj)
           if isempty(obj.M_FILE_ROOT)
               obj.M_FILE_ROOT = getUserConstants('-MENDELEY_FILE_ROOT');
               value = obj.M_FILE_ROOT;
           else
               value = obj.M_FILE_ROOT;
           end
        end
        function obj = mendeley_client(user_name)
%             if nargin == 0
%                 return
%             end

            obj.user_name = user_name;
            populatePaths(obj);
            populateAuthStruct(obj);
            obj.lib = mendeley_lib(obj); 

            %Constructor call to mendeley_lib, not method
            %obj.lib = mendeley_lib(obj);
            %Make this upon request ...
        end
        
%         function performSearch(obj)
%             
%         end
        
    end
    
    methods (Static, Hidden)
       createUserAccount_cb(~,~,option)
    end
    
    methods (Static)
        s = parseEntry(curEntry)
        createUserAccount
        function openRoot
           %openRoot opens Mendeley file root
           openExplorerToPath(mendeley_client.M_FILE_ROOT);
        end
    end

end

