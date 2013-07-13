function createUserAccount_cb(~,~,option)
%
%   JAH TODO: Document function
%
%   See Also:
%       mendeley_client.createUserAccount


f = gcbf;
h = getappdata(f,'h');

%LINK PROCESSING
%--------------------------------------------------------------
if strcmp(option,'link')
    a = getappdata(f,'auth_struct');
    obj = mendeley_oauth(a.consumer_key,a.consumer_secret);
    
    setappdata(f,'oauth_obj',obj)
    
    initialize_request_token_session(obj);
    sign_request(obj);
    [success,extras] = getRequestToken(obj);
    
    if ~success
        disp(extras.response)
        msgbox('Failed to get request token, see command window for reason')
        return
    end
    
    tempURL = getAuthorizeRequestTokenURL(obj,false);
    openWebBrowser(tempURL);
    return
end

%SAVE PROCESSING
%-------------------------------------------------------------
%DONE Check that verifier is not empty
%DONE Check username not empty
%DONE Check that username is not already taken by checking for auth file

vText = get(h.text_verifier,'String');
uName = get(h.text_username,'String');
if isempty(vText)
    msgbox('Verifier window is empty, should have verifier text');
    return
end

if isempty(uName)
    msgbox('User name window is empty, should have user name');
    return
end

client_obj = mendeley_client;
populatePaths(client_obj,uName)

if exist(client_obj.user_creds_path,'file')
    msgbox('Specified user name already exists and has credentials');
    return
end

oauth_obj = getappdata(f,'oauth_obj');
initialize_access_token_session(oauth_obj,vText);
sign_request(oauth_obj);
[success,token,extras] = getAccessToken(oauth_obj);

if ~success
    disp(extras.response)
    msgbox('Failed to get access token, see command window for reason')
    return
end

createFolderIfNoExist(client_obj.user_root_path);
fid = fopen(client_obj.user_creds_path,'w');
fprintf(fid,'oauth_access_token: %s\n',token.oauth_access_token);
fprintf(fid,'oauth_access_token_secret: %s\n',token.oauth_access_token_secret);
fclose(fid);

msgbox('Success!')
close(f)

end