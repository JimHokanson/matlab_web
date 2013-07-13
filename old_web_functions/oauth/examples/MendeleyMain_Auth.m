%The following serves as an example on how to get an access token
%using calls to the oauth library
%
%   NOTE: Some of this code is speific to Mendeley
%   

writeResultToFile    = false;
writeResultDirectory = 'C:\D\MendeleyUserInfo';
programID            = 'JimsMendeleyProgram';
userID               = 'CAA';

if writeResultToFile && ~exist(writeResultDirectory,'dir')
    error(['Please either set writeResultToFile to false or change' ...
        'writeResultDirectory to a directory that exists'])
end


%INFORMATION FOR TOKENS
%=========================================================================


%JAH TODO: rewrite with code from tester
% % % % % clear classes
% % % % % consumer_key    = '0d7ea6c3fceabc7f224dfa3391f4754604cf5c550';
% % % % % consumer_secret = '23365a12f8cd2b741549939c0bf9c1f5';
% % % % % REQUEST_URL = 'http://www.mendeley.com/oauth/request_token/';
% % % % % AUTH_URL    = 'http://www.mendeley.com/oauth/authorize/';
% % % % % ACCESS_URL  = 'http://www.mendeley.com/oauth/access_token/';
% % % % % obj = mendeley_oauth(consumer_key,consumer_secret);
% % % % % 
% % % % % 
% % % % % success = getRequestToken(obj);
% % % % % tempURL = getAuthorizeRequestTokenURL(obj,true);
% % % % % 
% % % % % verifier = '874cb31dec';
% % % % % [success,token,extras] = getAccessToken(obj,verifier);

CONSUMER_KEY    = '0d7ea6c3fceabc7f224dfa3391f4754604cf5c550';
CONSUMER_SECRET = '23365a12f8cd2b741549939c0bf9c1f5';

%GETTING THE REQUEST TOKEN
%==========================================================================
obj  = oauth(CONSUMER_KEY,CONSUMER_SECRET);
sOut = obj.getRequestToken;

sOut = oauth_action_requestToken(REQUEST_URL,authStruct);
if ~strcmp(sOut(1:5),'oauth')
    error('Unsuccessful request for requestToken')
end
requestOutput = requestStringToParamValueStruct(sOut);

authStruct.oauth_token = requestOutput.oauth_token;
authStruct.oauth_token_secret = requestOutput.oauth_token_secret;

%AUTHORIZATION OF REQUEST TOKEN
%==========================================================================
urlAddress   = oauth_action_authorizeRequestToken(AUTH_URL,authStruct.oauth_token);
fprintf(2,'Please enter the address in the clipboard into a browser window\n');
verifier     = input('Please enter the verifier >>','s');

%GETTING THE ACCESS TOKEN
%==========================================================================
sOut = oauth_action_accessToken(ACCESS_URL,authStruct,verifier);
if ~strcmp(sOut(1:5),'oauth')
    error('Unsuccessful request for accesstToken')
end
accessOutput = requestStringToParamValueStruct(sOut);

summaryCell = {...
    'requestToken',         authStruct.oauth_token;
    'requestTokenSecret',   authStruct.oauth_token_secret;
    'verifier',             verifier;
    'accessToken',          accessOutput.oauth_token;
    'oauth_token_secret',   accessOutput.oauth_token_secret;
    'userID',               userID};
%summaryStruct = cell2struct(summaryCell(:,2),summaryCell(:,1));

if writeResultToFile
    finalFileName = sprintf('%s_%s_%s.txt',programID,userID,verifier);
    fid = fopen(fullfile(writeResultDirectory,finalFileName),'w');
    for iProp = 1:size(summaryCell,1)
       fprintf(fid,'%s\t%s \r\n',summaryCell{iProp,1},summaryCell{iProp,2}); 
    end
    fclose(fid);
end
    
    
    
    