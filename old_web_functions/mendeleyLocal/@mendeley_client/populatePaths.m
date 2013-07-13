function populatePaths(obj,test_user_name)
%populatePaths
%
%   Populates class paths. It does not test if these paths exist or do
%   folder creation ...
%
%   FORMS
%   ================================================
%   1) The normal form
%   populatePaths(obj)
%
%   2) For account creation the following form is allowed:
%   populatePaths(obj,test_user_name)

if exist('test_user_name','var')
    local_user_name = test_user_name;
else
    local_user_name = obj.user_name;
end

rootPath  = fullfile(obj.M_FILE_ROOT,local_user_name);

obj.user_creds_path  = fullfile(rootPath,'authInfo.txt');
obj.api_creds_path   = fullfile(obj.M_FILE_ROOT,'api_account_info.txt');
obj.user_docIDs_path = fullfile(rootPath,'docIDs.mat');
obj.user_libMat_path = fullfile(rootPath,'lib.mat');
obj.user_test_path   = fullfile(rootPath,'tester_path');
obj.user_root_path   = rootPath;
