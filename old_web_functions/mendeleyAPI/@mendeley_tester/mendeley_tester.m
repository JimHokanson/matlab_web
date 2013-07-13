classdef mendeley_tester < handle
    %
    %   c = mendeley_client('JAH');
    %   obj = mendeley_tester.createFromClient(c);
    
    properties (Constant)
       MAT_VERSION = 1 
    end
    
    properties
        auth_struct
        
        pvt_doc_methods = {...
            'mendeley_pvt_doc_authored'
            'mendeley_pvt_doc_createEntry'
            'mendeley_pvt_doc_deleteEntry'
            'mendeley_pvt_doc_details'
            'mendeley_pvt_doc_downloadFile'
            'mendeley_pvt_doc_library'
            'mendeley_pvt_doc_uploadFile'
            }
        
        pvt_folder_methods = {...
            'mendeley_pvt_folder_add_doc.m'
            'mendeley_pvt_folder_create.m'
            'mendeley_pvt_folder_delete.m'
            'mendeley_pvt_folder_documents.m'
            'mendeley_pvt_folder_list.m'
            'mendeley_pvt_folder_rem_doc.m'};
        
        pvt_group_methods = {...
			'mendeley_pvt_group_create.m'
			'mendeley_pvt_group_delete.m'
			'mendeley_pvt_group_documents.m'
			'mendeley_pvt_group_doc_details.m'
			'mendeley_pvt_group_list.m'
			'mendeley_pvt_group_people.m'};
        
        pvt_profile_methods = {...
			'mendeley_pvt_profile_add_contact.m'
			'mendeley_pvt_profile_contacts.m'
			'mendeley_pvt_profile_info.m'};
        
        pvt_stats_methods = {...
			'mendeley_pvt_stats_authors.m'
			'mendeley_pvt_stats_pub.m'
			'mendeley_pvt_stats_tag.m'};
        
        test_directory
    end
    
    methods
        function obj = mendeley_tester(authStruct)
            obj.auth_struct = authStruct;
        end
        
        function runTest(obj)
            %Implement this ...
        end
        
        %JAH STATUS NOTICE:
        %This is still very much a work in progress

        function test_pvt_doc_methods(obj)
            [flag,id] = pvt_doc_createEntry(obj);
            
            %method still in flux
            %flag = pvt_doc_uploadFile(obj,id);
            [flag,output] = pvt_doc_details(obj,id);
            
        end
        
        function test_pvt_folder_methods(obj)
            
        end
        
        function test_pvt_group_methods(obj)
            
        end
        
        function test_pvt_profile_methods(obj)
            
        end
        
        function test_pvt_stats_methods(obj)
            
        end
        
        function test_pub_search_methods(obj)
           flag = pub_search_authored(obj);
           
        end

        %Public Search Methods
        
        function flag = pub_search_authored(obj)
            name    = 'RB Stein';
            page    = '';
            items   = '';
            year    = '1980';
           [output,otherStruct] = mendeley_pub_search_authored(obj.auth_struct,name,page,items,year);
           flag = true;
        end
        
        %Private Document methods
        %==================================================================================
        
        function pvt_doc_all(obj)
           [flag,id] = pvt_doc_createEntry(obj);
           flag      = pvt_doc_uploadFile(obj,id); 
        end
        
        function flag = pvt_doc_authored(obj)
            [output,otherStruct] = mendeley_pvt_doc_authored(obj.auth_struct);
            flag = otherStruct.status.value == 200;
            compareAndSave(obj,'mendeley_pvt_doc_authored',output)
        end
        
        function [flag,id] = pvt_doc_createEntry(obj)
              newEntry = struct;
              newEntry.title = ['This ? is a t'  char(683) 'st']; %char(233) accent
              newEntry.type  = 'Journal Article';
              newEntry.year  = '2006';
              newEntry.notes = datestr(now);
              newEntry.authors = {'Wtf'};

            [output,otherStruct] = mendeley_pvt_doc_createEntry(obj.auth_struct,newEntry);
            flag = otherStruct.status.value == 201;
            if flag
                id = output.document_id;
            else
                id = '';
            end
            compareAndSave(obj,'mendeley_pvt_doc_createEntry',output,otherStruct)
        end
        
        function flag = pvt_doc_deleteEntry(obj,id_to_delete)
            [output,otherStruct] = mendeley_pvt_doc_deleteEntry(obj.auth_struct,id_to_delete);
            if isempty(output) || ~output
                flag = false;
            else
                flag = true;
            end
            compareAndSave(obj,'mendeley_pvt_doc_deleteEntry',output,otherStruct)
        end
        
        function [flag,output] = pvt_doc_details(obj,id)
            %
            %
            
            %
            [output,otherStruct] = mendeley_pvt_doc_details(obj.auth_struct,id);
            flag = otherStruct.status.value == 200;
            compareAndSave(obj,'mendeley_pvt_doc_details',output,otherStruct)
        end
        
        function pvt_doc_downloadFile(obj,id)

            
        end
        
        function flag = pvt_doc_library(obj)
            [output,otherStruct] = mendeley_pvt_doc_library(obj.auth_struct,0,30);
            flag = otherStruct.status.value == 200;
            compareAndSave(obj,'mendeley_pvt_doc_library',output,otherStruct)
        end
        
        function flag = pvt_doc_uploadFile(obj,id)
            filePath = fullfile(getMyPath,'UploadTest.pdf');
            isFilePath = true;
            [output,otherStruct] = mendeley_pvt_doc_uploadFile(obj.auth_struct,id,filePath,isFilePath);
            flag = otherStruct.status.value == 201;
            compareAndSave(obj,'mendeley_pvt_doc_uploadFile',output,otherStruct)
        end
        
        %compareAndSave(obj,fcn_name)
        
       
        
    end
    
    methods (Static)
        %m = mendeley_tester.createFromClient(c)
        function obj = createFromClient(c)
           obj = mendeley_tester(c.auth_struct);
           obj.test_directory = c.user_test_path;
           if ~exist(obj.test_directory,'dir')
              mkdir(obj.test_directory);
           end
        end
        
        function all_ca = listMethods
           parent_dir = fileparts(getMyPath);
           pvt_path = fullfile(parent_dir,'privateMethods');
           pvt_dirs = {'document_methods' 'folder_methods' 'group_methods' 'profile_methods' 'stats_methods'};
           pvt_names = {'doc' 'folder' 'group' 'profile' 'stats'};
           
           nRoots = length(pvt_dirs);
           all_ca = cell(1,nRoots);
           for iRoot = 1:nRoots
              curDir = fullfile(pvt_path,pvt_dirs{iRoot});
              temp = getDirectoryTree(curDir,'',false,'\.m','files');
              variable_name = sprintf('pvt_%s_methods',pvt_names{iRoot});
              all_ca{iRoot} = sprintf('%s = {...\n\t\t\t''%s''};',variable_name,cellArrayToString(temp,'''\n\t\t\t'''));
           end
        end
    end
    
end

