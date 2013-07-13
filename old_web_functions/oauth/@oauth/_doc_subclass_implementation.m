%{

subclass_implementation

ABSTRACT PROPERTIES
------------------------------------------------------------------------
REQUEST_URL
AUTH_URL
ACCESS_URL

ABSTRACT METHODS
------------------------------------------------------------------------
output = getOauthInfo(obj,http_method,url,params,varargin)
[success,token,extras] = getAccessToken(obj,verifier)
[success,extras]       = getRequestToken(obj)

%=======================================================================

IMPLEMENTING FUNCTION getRequestToken:
----------------------------------------------------------------------------
1) Use init_request_params(obj) to setup the authentication parameters for a request
2) Use getRequestToken_Helper(obj) to make the request
3) Parse the response and call setRequestToken 

Possible changes:
1) After initializing the request parameters, it may be desirable to edit
the default parameters, see section "EDITING PARAMETERS"

Possible helpers:
1) Parsing the response
http_queryStringToParams can be used to parse the response if returned in
urlencoded format.The following chunk of code might be helpful, where "output" is the body of
the response from the server:

CODE:
temp = http_queryStringToParams(output);
s    = cell2struct(temp(2:2:end),temp(1:2:end),2);

2) The Status of the response can be found in the 2nd ouput from the
function getRequestToken_Helper(obj)

[output,extras] = getRequestToken_Helper(obj);
extras.status.value contains the numeric status code returned by the server


IMPLEMENTING FUNCTION getAccessToken:
----------------------------------------------------------------------------


%}