classdef oauth < handle
    %oauth  Implements Version 1 of OAuth
    %
    %   ABSTRACT - requires implementation classes
    %
    %   OVERVIEW
    %   =====================================================================
    %   This code consists of three classes:
    %       1) oauth (abstract)
    %       2) an implementation of this class (supplied by user, not in oauth codebase)
    %       3) oauth_params : a class for handling oauth parameters
    %
    %   ABSTRACT IMPLEMENTATION
    %   =====================================================================
    %   A subclass must be created to implement this class. These subclasses
    %   are meant to be specific to a particular server, handling small
    %   differences between different servers' implementations. More
    %   documentation on implementing a subclass can be found at under the
    %   documentaton folder in a file called subclass_implementation
    %
    %   GENERAL USAGE
    %   =====================================================================
    %   A user typically only needs the following functions:
    %       access_token_example (generally once per user)
    % 
    %
    %
    %   DOCUMENTATION NOT IN THIS FILE
    %   ======================================================================
    %   _doc_improvements            - notes to self (and others) on things to improve
    %   _doc_methods                 - documentation of methods
    %   _doc_subclass_implementation - how to implement this abstract class
    %   retrievingAnAccessToken - how to get an access token for requesting personal data
    %
    %   version_info            - notes on version changes
    %
    %
    %
    %   METHOD SUMMARIES
    %   ======================================================================
    %   getAccessTokenStruct
    %
    %   Static Methods:
    %   ----------------------------
    %   percentEncodeString
    %   depercentEncode
    %   createAuthStruct
    
    
    
    %OUTSIDE DEPENDENCIES
    %--------------------------------------------------
    %   sortCellArrayRows
    %   cellArrayToString
    %   http_queryStringToParams
    %   http_paramsToQuery
    
    %GENERAL OAUTH HELPER FUNCTIONS
    %------------------------------------------------------
    
    %FOR HELP WITH DEVELOPING IMPLEMENTATIONS
    %------------------------------------------------------
    %getDefaultRequestTokenParams
    %getDefaultAccessTokenParams
    
    
    %METHODS
    %-------------------------------------
    %action_accessToken -
    %
    %
    %
    %   SIGNATURE METHODS
    %   ----------------------------------------------------------
    %   getSignature
    %       - oauth.createBaseString
    %           - oauth.normalizeParams(params);
    %
    
    
    
    
    properties (Constant)
        Version = 1
    end
    
    properties (Abstract, Constant)
        %Should be specified in the implementation class
        REQUEST_URL
        AUTH_URL
        ACCESS_URL
    end
    
    properties (Hidden, SetAccess = protected)
        request_token_auth_params %Authentication params for getting request token
        request_token_user_params
        access_token_auth_params  %Authentication params for getting access token
        access_token_user_params
        general_auth_params    	  %Authentication params for API methods
        general_user_params         	  %Parameters used for API methods
        general_url = ''          %url for oauth request, needed for signing
    end
    
    
    
    
    
    %=====================================================================
    %   Properties that are interesting to the user and that try
    %   and hide some of the behind the scenes action
    %=====================================================================
    
    properties
        http_method = '';
    end
    
    properties (Dependent)
        url = ''; %Dependent since it is populated either from a constant or the hidden general url
    end
    
    properties (Transient)
        auth_params
        user_params
        proper_authorization_set
        is_signed
    end
    
    %=====================================================================
    %Properties manipulated via method that might be interesting to user
    %=====================================================================
    properties (SetAccess = private)
        current_request_type = 'general'  %Set via initialization calls
        is_public_request    = false;       %If true indicates that an access token is not needed
        %NOTE: This is currently must be set on initialization of the
        %general parameters structure
        auth_header
    end
    
    %=====================================================================
    %	Options to change, should in general be changed after construction
    %=====================================================================
    properties
        opt_signature_method         = 'HMAC-SHA1';
        opt_http_param_encoding_option = 2; %See http_paramsToString
        opt_u_use_cookies = false; %use cookies on urlread2
        
        %OAUTH_PARAMS RELATED
        %------------------------------------------------------------------
        opt_allow_empty_oauth_params = true;
        opt_cast_numbers_to_strings  = false; %If false and #s are found, then an error occurs
        opt_number_to_string_fhandle = @int2str; %Function used to convert #s to string
        opt_convert_params_to_utf8   = true;
    end
    
    %====================================================================
    %                   AUTHORIZATION PROPERTIES
    %====================================================================
    properties (Hidden)
        consumer_key
        consumer_secret
        
        %REQUEST TOKEN
        %-----------------------------------
        oauth_request_token
        oauth_request_token_secret
        %Nothing done with these yet
        oauth_request_ttl = -1
        oauth_request_set_time
        
        %ACCESS TOKEN
        %-----------------------------------
        oauth_access_token
        oauth_access_token_secret
    end
    
    properties (Transient, Hidden)
        token_secret
    end
    
    methods
        function obj = oauth(consumer_key,consumer_secret)
            %oauth
            %
            %   obj = oauth(consumer_key,consumer_secret)
            %
            %   obj = oauth(authStruct)
            %
            %   INPUTS
            %   =================================
            %   authStruct : (structure)
            %       .consumer_key
            %       .consumer_secret
            %       .oauth_access_token
            %       .oauth_access_token_secret
            
            %This could be for debugging some of the static methods
            if nargin == 0
                return
            end
            %NOTE: I don't include a method for setting these properties.
            %This would require handling switching of authorization parameters ...
            %Anything signed would need to cleared
            
            if isstruct(consumer_key)
                auth_struct = consumer_key;
                obj.consumer_key              = auth_struct.consumer_key;
                obj.consumer_secret           = auth_struct.consumer_secret;
                obj.oauth_access_token        = auth_struct.oauth_access_token;
                obj.oauth_access_token_secret = auth_struct.oauth_access_token_secret;
            else
                obj.consumer_key    = consumer_key;
                obj.consumer_secret = consumer_secret;
            end
        end
    end
    
    %SET/GET FUNCTIONALITY FOR PROPERTIES
    %=========================================================
    methods
        function value = get.token_secret(obj)
            switch obj.current_request_type
                case 'request'
                    value = ''; %For getting a request token, we have no token
                case 'access'
                    value = obj.oauth_request_token_secret; %For getting an access token, we use our request token
                case 'general'
                    if obj.is_public_request
                        value = '';
                    else
                        value = obj.oauth_access_token_secret;
                    end
            end
        end
        function set.opt_signature_method(obj,value)
            if ~isempty(obj.auth_params) %#ok<MCSUP>
                error('Currently unable to set signature method after initialization of session')
            else
                obj.opt_signature_method = value;
            end
        end
        function set.opt_number_to_string_fhandle(obj,value)
            if ~isa(value,'function_handle')
                error('Property opt_number_to_string_fhandle must be a function handle')
            else
                obj.opt_number_to_string_fhandle = value;
            end
        end
        function set.url(obj,value)
            if ~strcmp(obj.current_request_type,'general')
                error('Unable to set url if current_request_type is not set to ''general''');
            else
                obj.general_url = value;
            end
        end
        function value = get.url(obj)
            switch (obj.current_request_type)
                case 'access'
                    value = obj.ACCESS_URL;
                case 'request'
                    value = obj.REQUEST_URL;
                case 'general'
                    value = obj.general_url;
            end
        end
        function value = get.is_signed(obj)
            value = ~isempty(obj.auth_header);
        end
        function set.http_method(obj,value)
            obj.http_method = upper(value);
        end
        function set.current_request_type(obj,value)
            switch (value)
                case {'access' 'general' 'request'}
                    obj.current_request_type = value;
                otherwise
                    error('Unrecognized request type: %s, valid options are: access, general, and request')
            end
        end
        function value = get.auth_params(obj)
            switch obj.current_request_type
                case 'general'
                    value = obj.general_auth_params;
                case 'request'
                    value = obj.request_token_auth_params;
                case 'access'
                    value = obj.access_token_auth_params;
            end
        end
        function value = get.user_params(obj)
            switch obj.current_request_type
                case 'general'
                    value = obj.general_user_params;
                case 'request'
                    value = obj.request_token_user_params;
                case 'access'
                    value = obj.access_token_user_params;
            end
        end
        function value = get.proper_authorization_set(obj)
            pub = ~isempty(obj.consumer_secret);
            pvt = ~isempty(obj.oauth_access_token_secret);
            switch obj.current_request_type
                case 'access'
                    value = pub;
                case 'request'
                    value = pub;
                case 'general'
                    if obj.is_public_request
                        value = pub;
                    else
                        value = pub && pvt;
                    end
            end
        end
    end
    
    methods(Abstract,Static)
        access_token_example(consumer_key,consumer_secret)
    end
    
    methods
        function token = getAccessTokenStruct(obj)
            %getAccessTokenStruct  Returns "access" token structure for future calls
            %
            %   %NOTE: It might be desirable to override this with the subclass
            %   implementation if more info is needed
            token = struct(...
                'oauth_access_token',obj.oauth_access_token,...
                'oauth_access_token_secret',obj.oauth_access_token_secret);
        end
    end
    
    methods
        function [success,token,extras] = getAccessToken(obj)
            %getAccessToken Retrieve an "access" token from Mendeley
            %[success,token,extras] = getAccessToken(obj,verifier)

            h = get_http_request_struct(obj);
            [url,method,body,headers] = http_expandRequestStruct(h);
            [output,extras] = urlread2(url,method,body,headers,...
                'USE_COOKIES',obj.opt_u_use_cookies);
            
            success = extras.status.value == 200;
            if ~success      
                token = [];
                extras.response = output;
            else
                s = http_queryStringToParams(output);
                setAccessToken(obj,s.oauth_token,s.oauth_token_secret)
                token = getAccessTokenStruct(obj);
                extras.response = s;
            end
        end          
        function [success,extras] = getRequestToken(obj)
            %getRequestToken Retrieve a "request" token from Mendeley
            %
            %   [success,extras] = getRequestToken(obj)

            h = get_http_request_struct(obj);
            [url,method,body,headers] = http_expandRequestStruct(h);
            [output,extras] = urlread2(url,method,body,headers,...
                'USE_COOKIES',obj.opt_u_use_cookies);
            
            success = extras.status.value == 200;
            if ~success     
                extras.response = output;
            else
                s = http_queryStringToParams(output);
                setRequestToken(obj,s.oauth_token,s.oauth_token_secret,'ttl',s.xoauth_token_ttl);
                extras.response = s;
            end
        end        
    end
    
    methods (Access = private, Hidden)
        [oSignature,debugStruct] = getSignature(obj,http_method);
        baseString = createBaseString(obj)
    end
    
    methods (Hidden, Sealed, Access = protected)
        setRequestToken(obj,token,secret,varargin)
        setAccessToken(obj,token,secret,varargin)
    end
    
    methods (Hidden)
        function disp(obj)
            builtin('disp',obj)
            fprintf('        <a href="matlab:methods(%s)">%s</a>\n',class(obj),'Detailed Methods');
        end
    end
    
    methods
        function http_struct = get_http_request_struct(obj)
            %get_http_request_struct Populates basic structure for making http request
            %
            %
            %   NOTES: This 
            %
            %   OUTPUTS
            %   ========================================================
            %   http_struct: structure
            %       .url     - final url (with parameters)
            %       .method  - http method (GET, POST, etc) (used with oauth encoding)
            %       .body    - 
            %       .headers
            %
            %   See Also:
            %       http_createRequestStruct
            
            %NOTES:
            % calls oauth_params.getQueryString on the method parameters
            % fetches auth_header
            
            [str,header] = getQueryString(obj.user_params);
            
            headers = obj.auth_header;
            body    = '';
            url_out = obj.url;
            %URL HANDLING
            %----------------------------------
            if strcmp(obj.http_method,'GET') && ~isempty(str)
            	url_out = [url_out '?' str];
            end
            
            if strcmp(obj.http_method,'POST')
               body    = str;
               headers = [header obj.auth_header];
            end
            
            http_struct = http_createRequestStruct(url_out,obj.http_method,body,headers);
            
    
        end
        function initialize_request_token_session(obj)
            %initialize_request_token_session Initializes params and settings for getting a request token
            obj.request_token_auth_params = oauth_params.init_request_auth_params(obj);
            obj.request_token_user_params = oauth_params.init_user_params(obj);
            obj.current_request_type      = 'request';
            obj.http_method = 'GET';
            obj.is_signed   = false;
        end
        function initialize_access_token_session(obj,verifier)
            %initialize_access_token_session Initializes params and settings for getting an access token
            verifier = strtrim(verifier);
            obj.access_token_auth_params = oauth_params.init_access_auth_params(obj,verifier);
            obj.access_token_user_params = oauth_params.init_user_params(obj);
            obj.current_request_type     = 'access';
            obj.http_method = 'GET';
            obj.is_signed   = false;
        end
        function initialize_general_access_session(obj,is_public_request,http_method,url,params)
            %initialize_general_access_session
            %
            %   initialize_general_access_session(obj,is_public_request,http_method,url,params)
            %
            %
            obj.is_public_request    = is_public_request;
            obj.general_auth_params  = oauth_params.init_general_auth_params(obj);
            obj.general_user_params  = oauth_params.init_user_params(obj,params);
            obj.current_request_type = 'general';
            obj.url         = url;
            obj.http_method = http_method;
            obj.is_signed   = false;
        end
        function sign_request(obj)
            %sign_request Get's the Oauth signature for the request
            %
            %   sign_request(obj)
            
            %JAH TODO: make this error more explicit
            %Only happens when not provided with constructor, should always
            %be unless debugging or doing methods inspection
            if ~obj.proper_authorization_set
                error('Proper authorization credentials not yet provided')
            end
            
            if isempty(obj.auth_params)
                error('Authorization parameters must be initialized before calling this function');
            end
            
            debugStruct     = getSignature(obj); %#ok<NASGU> I sort of like keeping the output around
            obj.auth_header = getAuthorizationHeader(obj.auth_params);
        end
    end
    
    methods (Static)
        outputStr = percentEncodeString(inputStr,fixForwardSlash);
        str2      = depercentEncode(str);
        function s = createAuthStruct(consumer_key,consumer_secret,oauth_token,oauth_token_secret)
            %createAuthStruct  Creates authorization structure for use with constructor
            %
            %   s = createAuthStruct(consumer_key,consumer_secret,oauth_token,oauth_token_secret)
            
            s.consumer_key              = consumer_key;
            s.consumer_secret           = consumer_secret;
            s.oauth_access_token        = oauth_token;
            s.oauth_access_token_secret = oauth_token_secret;
        end
        function output = get_SHA1(data)
            %get_SHA1 Creates message digest using SHA-1 hash function
            %
            %    output = get_SHA1(data)
            
            %data = 'The quick brown fox jumps over the lazy dog';
            digest = org.apache.commons.codec.digest.DigestUtils;
            temp   = lower(dec2hex(typecast(digest.sha(data),'uint8')))';
            output = temp(:)';
            
        end
    end
    
    %Simple static methods for internal use - hidden to hide clutter in public methods
    methods (Static, Hidden)
        time_t = getTimestamp
        nonce  = getNonce()
    end
end

