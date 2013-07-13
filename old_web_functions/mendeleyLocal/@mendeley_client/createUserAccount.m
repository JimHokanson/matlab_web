function createUserAccount
%createUserAccount
%
%   This function allows creation of an API account for accessing private
%   data from the user ...
%
%   mendeley_client.createUserAccount
%
%   JAH TODO: Document function
%


obj = mendeley_client;
populatePaths(obj);
if ~exist(obj.api_creds_path,'file')
    error('Missing API credentials for program, see Jim')
end

populateAuthStruct(obj,true) %NOTE: I wish this 

%NOTE: This might cause an error if not set
m_file_root = obj.M_FILE_ROOT;

class_path = getMyPath;
fig_root   = fullfile(fileparts(class_path),'figs');
gui_path   = fullfile(fig_root,'mendeley_client_create_user.fig');
uiopen(gui_path,1);
figHandle = gcf;
h = guihandles(figHandle);
setappdata(figHandle,'m_file_root',m_file_root)
setappdata(figHandle,'h',h);
setappdata(figHandle,'auth_struct',obj.auth_struct);

%Get consumer_key and consumer_secret

set(h.text_verifier,'String','');
set(h.text_username,'String','');

set(h.button_getWebsiteLink,'callback',{@mendeley_client.createUserAccount_cb 'link'});
set(h.button_Save,'callback',{@mendeley_client.createUserAccount_cb 'save'});
end