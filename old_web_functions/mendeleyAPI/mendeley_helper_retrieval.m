function [output,extras] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE,isPublic,varargin)
%mendeley_helper_retrieval Makes call to Mendeley for data
%
%   [output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE,*isPublic)
%
%   This function handles parameter processing and filtering, as well as
%   oAuth signing and output type conversion
%
%   JAH TODO: Finish documentation
%
%   INPUTS
%   =======================================================================
%   httpMethod :
%   url        :
%   authStruct :
%   myParamsPE : 
%   
%   isPublic   :
%
%   OUTPUTS
%   =======================================================================
%   output     : format depends on content type, typically json, content
%                depends on the calling function and should be handled by
%                the calling function
%   otherStruct : (structure)
%       .raw    - raw output before being processed
%       .OTHERS NEED TO BE DOCUMENTED

%Most likely need to add casting option for retrieving data
DEFINE_CONSTANTS
CAST_OUTPUT = true;
extra_auth_params       = {};
allow_empty_params      = false;
cast_numbers_to_strings = true;
body_to_use     = [];
extra_headers   = [];
END_DEFINE_CONSTANTS

if ~exist('isPublic','var'), isPublic = false; end
assert(isstruct(authStruct),'authStruct must be a structure')


obj = mendeley_oauth(authStruct);
obj.opt_allow_empty_oauth_params = allow_empty_params;
obj.opt_cast_numbers_to_strings  = cast_numbers_to_strings;


initialize_general_access_session(obj,isPublic,httpMethod,url,myParamsPE)

if ~isempty(extra_auth_params)
   obj.auth_params.addParams(extra_auth_params);
end

sign_request(obj);

http_struct = get_http_request_struct(obj);

[url,method,body,headers] = http_expandRequestStruct(http_struct);

if ~isempty(body_to_use)
    body = body_to_use;
end

if ~isempty(extra_headers)
    headers = [headers extra_headers];
end

%Data retrieval
%--------------------------------------------------------------------------
%not using cookes saves time ...
[tempOut,extras] = urlread2(url,method,body,headers,'USE_COOKIES',false,'CAST_OUTPUT',CAST_OUTPUT);
extras.raw = tempOut;

status     = extras.status;
headersOut = extras.firstHeaders;
%Output processing
%--------------------------------------------------------------------------
if status.value >= 200 && status.value < 300
    if status.value == 204 && isempty(tempOut);
        output = true;
    else
        switch lower(headersOut.Content_Type)
            case 'application/json'
                output = parse_json(tempOut);
            otherwise
                fprintf(2,'Unrecognized type: %s\n',headersOut.Content_Type);
                keyboard
        end
    end
else
    disp('The following response was obtained:')
    disp(tempOut)
    error('Unexpected response obtained, please debug')
end