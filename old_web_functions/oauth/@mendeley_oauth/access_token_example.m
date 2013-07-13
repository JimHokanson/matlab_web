function access_token_example(consumer_key,consumer_secret)
%access_token_example Code to get an access token from Mendeley
%
%   mendeley_oauth.access_token_example(consumer_key,consumer_secret)

obj = mendeley_oauth(consumer_key,consumer_secret);

%Request Token Handling
%=================================================
initialize_request_token_session(obj);
sign_request(obj);
[success,extras] = getRequestToken(obj);

if ~success
    disp(extras.response)
    error('Failed to get request token')
end

%Authorization of request token
%================================================
tempURL = getAuthorizeRequestTokenURL(obj,true);

fprintf(2,'--------------------------------------------------------------------\n');
fprintf('Paste url from clipboard into browser to authenticate\n-');
fprintf('Alternatively, use the url on the next line:\n');
disp(tempURL)
fprintf('Please paste the verifier on the next line\n');
verifier = input('verifier = ','s');

if isempty(strtrim(verifier))
   fprintf(2,'Process quit\n'); 
end

%Access Token Handling
%=================================================
initialize_access_token_session(obj,verifier);
sign_request(obj);
[success,token,extras] = getAccessToken(obj);

if ~success
    disp(extras.response)
    error('Failed to get access token')
end

fprintf('---  Token -----------------------------------------\n')
disp(token)
fprintf('---  Full Response From Server ---------------------\n')
disp(extras.response)