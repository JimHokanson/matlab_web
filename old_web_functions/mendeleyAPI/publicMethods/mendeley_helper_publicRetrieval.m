function [output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams)
%mendeley_helper_publicRetrieval
%
%   [output,status,raw] = mendeley_helper_publicRetrieval(URL,authStruct,myParams)
%
%   This function assumes a GET request is going to be made for the public
%   method.
%
%   JAH TODO: Finish documentation
%
HTTP_METHOD = 'GET';

% %if true
    myParams = mendeley_helper_removeEmptyParams(myParams);
    params = oauth_getAuthParams(HTTP_METHOD,URL,authStruct,myParams,'two_legged_oauth');
    [tempOut,status] = oauth_urlread(URL,params,HTTP_METHOD,myParams);
% % else
% %     %QUICK PUBLIC METHOD TEST
% %     %======================================================================
% %     %This uses a get query instead of the authentication header
% %     myParams = mendeley_helper_removeEmptyParams(myParams);
% %     myParams = [myParams {'consumer_key' authStruct.consumerKey}];
% %     newURL  = get_url_with_query(URL,myParams);
% %     tempOut = urlread(newURL);
% %     status  = struct('Response','200');
% % end

if isempty(strfind(status.Response,'200'))
   disp('The following response was obtained:')
   disp(status.Response)
   status.errorMsg = tempOut;
   disp(tempOut)
   output = '';
   raw = tempOut;
else
   output = parse_json(tempOut);
   raw = tempOut;
end