classdef pittcat_user < handle
    %pittcat_user
    
    properties
        filepath_requestsMadeLog
        path_libraryInfo
        filepath_login
    end

    properties
        twoP        %For ILL
        lastName    %where used?
        requestor   %Where is this used ????
        email       %Where used????
        department  %For ILL
        pcat_u
        pcat_p
        is_uls      %Whether or not we have access to uls
        is_hsls     %Whether or not we have access to hsls
        student_type %For ILL
    end
    
    properties (Constant)
       STUDENT_TYPE_OPTIONS = {'faculty' 'graduate student' 'undergraduate' 'staff'};
       CONSTANTS_PATH_NAME = 'LIBRARY_INFO_ROOT';
       g_pas     = 'WeqES8eq';
       g_account = 'rnel.papers@gmail.com';
    end

    
    methods
        function obj = pittcat_user
            
            C = getUserConstants(pittcat_user.CONSTANTS_PATH_NAME);

            obj.path_libraryInfo         = C.LIBRARY_INFO_ROOT;
            obj.filepath_login           = fullfile(obj.path_libraryInfo,'login.txt');
            obj.filepath_requestsMadeLog = fullfile(obj.path_libraryInfo,'libRequests.mat');

            %JAH TODO: Make function for doing this automagically
            if ~exist(obj.filepath_login,'file')
                error('The pittcat system requires a login.txt file to be setup')
            end

            output = readDelimitedFile(obj.filepath_login,':','strtrim_all',true);

            s = cell2struct(output(:,2),output(:,1));

            obj.twoP         = s.twoP;
            obj.lastName     = s.lastName;
            obj.requestor    = s.requestor;
            obj.email        = s.email;
            obj.department   = s.department;
            obj.pcat_p       = s.pcat_p;
            obj.pcat_u       = s.pcat_u;
            obj.is_uls       = s.is_uls;
            obj.is_hsls      = s.is_hsls;
            obj.student_type = s.student_type;
        end
    end
    
    methods (Static)
       %We could put a lot here to help out with things 
       function editLoginText 
          obj = pittcat_user;
          edit(obj.filepath_login)
       end
    end
    
end

