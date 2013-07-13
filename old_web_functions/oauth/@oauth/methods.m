function methods(obj,varargin)
%methods Function to improve display of info to user regarding available methods
%
%   methods(obj,varargin)
%
%   OPTIONAL INPUTS
%   ---------------------------------------------

REQUEST_FUNCTIONS = {'initialize_request_token_session' 'sign_request' 'getRequestToken' 'getAuthorizeRequestTokenURL'};
ACCESS_FUNCTIONS  = {'initialize_access_token_session'  'sign_request' 'getAccessToken' 'getAccessTokenStruct'};
GENERAL_FUNCTIONS = {'initialize_general_access_session' 'sign_request'};


groups(1).name = 'General Methods';
groups(1).fncs = GENERAL_FUNCTIONS;
groups(1).isSpecial = false;
groups(1).sort = false;

groups(2).name = 'static';
groups(2).isSpecial = true;

groups(3).name = 'Request Methods';
groups(3).fncs = REQUEST_FUNCTIONS;
groups(3).sort = false;

groups(4).name = 'Access Methods';
groups(4).fncs = ACCESS_FUNCTIONS;
groups(4).sort = false;

groups(5).name = 'unused';
groups(5).isSpecial = true;

groups(6).name = 'docs';
groups(6).isSpecial = true;

dispMethodsObject2(obj,groups,varargin{:});

return
