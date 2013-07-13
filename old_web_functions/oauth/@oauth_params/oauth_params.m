classdef oauth_params < handle
    %oauth_params
    %
    %   This class handles manipulation of parameters
    %
    %   For a general overview of usage of this class
    %   see the documentation with the oauth class
    %
    %   Parameters are simply a cell array vector. The cell array consists
    %   of property/value pairs. Properties MUST be strings and values
    %   should generally be strings although numbers are sometimes allowed
    %   (see optional properties)
    
    
    properties (SetAccess = protected)
        params = {};
    end
    
    properties (Hidden)
        parent %pointer to oauth object
    end
    
    methods (Access = private)
     function obj = oauth_params(oauth_obj)
            %oauth_params
            %
            %   obj = oauth_params(oauth_obj)
            %
            %   INPUTS
            %
            %   See Also:
            %       createGeneralParams - should only be called by oauth & derivatives of that class
            
            if nargin == 0
                return
            end
            
            obj.parent = oauth_obj;
            
            if isempty(oauth_obj.consumer_key)
                %NOTE: This is done in the constructor
                error('The Oauth Consumer key has not been specified yet, check the constructor call to the Oauth object')
            end
        end
        
    end
    methods (Static)
        function obj = init_request_auth_params(oauth_obj)
            obj = oauth_params(oauth_obj);
            obj.params = {...
                'oauth_consumer_key'        oauth_obj.consumer_key ...
                'oauth_signature_method'    oauth_obj.opt_signature_method ...
                'oauth_timestamp'           oauth_obj.getTimestamp ...
                'oauth_nonce'               oauth_obj.getNonce ...
                'oauth_callback'        'oob'};
            
        end    
        function obj = init_access_auth_params(oauth_obj,verifier)
            obj = oauth_params(oauth_obj);
            if isempty(oauth_obj.oauth_request_token)
                error('The request token is empty, getRequestToken() call needed')
            end
            obj.params = {...
                'oauth_consumer_key'        oauth_obj.consumer_key ...
                'oauth_token'               oauth_obj.oauth_request_token ...
                'oauth_signature_method'    oauth_obj.opt_signature_method ...
                'oauth_timestamp'           oauth_obj.getTimestamp ...
                'oauth_nonce'               oauth_obj.getNonce ...
                'oauth_verifier'            verifier};
        end       
        function obj = init_general_auth_params(oauth_obj)
            obj = oauth_params(oauth_obj);
            
            if oauth_obj.is_public_request
                access_line = {};
            else
                if isempty(oauth_obj.oauth_access_token)
                    error('The access token is empty, getAccessToken() or different constructor call needed')
                end
                access_line = {'oauth_token'	oauth_obj.oauth_access_token};
            end
            obj.params = [...
                'oauth_consumer_key'        oauth_obj.consumer_key ...
                access_line ... %Might be empty if public
                'oauth_signature_method'    oauth_obj.opt_signature_method ...
                'oauth_timestamp'           oauth_obj.getTimestamp ...
                'oauth_nonce'               oauth_obj.getNonce];
        end  
        function obj = init_user_params(oauth_obj,params)
        %init_user_params
           obj = oauth_params(oauth_obj);
           if exist('params','var')
              addParams(obj,params);
           end
        end
    end
    
    methods
        function params = getParams(obj)
            %getParams Returns parameters of object
            params = obj.params;
        end
        function addParams(obj,paramsToAdd)
            %addParams Adds additional parameters to object
            %
            %   addParams(obj,paramsToAdd)
            %
            %   INPUT
            %   ========================================================
            %   paramsToAdd: (params type, see class definition)
            %
            %   IMPORTANT: The current implementation overrides existing
            %   values if their is property name duplication

            oauth_params.verifyParams(paramsToAdd,true);
            paramsToAdd = processNewParams(obj,paramsToAdd);
            
            for iAdd = 1:2:length(paramsToAdd)
                property = paramsToAdd{iAdd};
                value    = paramsToAdd{iAdd+1};
                setParameter(obj,property,value);
            end
            
        end
        function deleteParams(obj,names)
            %deleteParams Removes parameters from object
            %
            %   deleteParams(obj,names)
            %
            %   INPUTS
            %   ========================================
            %   names: names of parameters to delete
            %
            %   NOTE: This current code doesn't care about properties
            %   to be deleted that aren't present ....
            
            I = find(ismember(obj.params(1:2:end),names));
            if ~isempty(I)
                deleteIndices = 2*I;
                deleteIndices = [deleteIndices-1 deleteIndices];
                obj.params(deleteIndices) = [];
            end
        end
        function addOauthSignature(obj,value)
            %addOauthSignature Adds oauth_signature property to params
            %
            %   addOauthSignature(obj,value)
            
            setParameter(obj,'oauth_signature',value);
        end
        function [str,header] = getQueryString(obj)
            %getQueryString Wrapper of http_paramsToString to produce query string
            %
            %   [str,header] = getQueryString(obj)
            %
            %   OUTPUTS
            %   =========================================
            %   str   : string to attach to URL for GET or place in body 
            %           for POST
            %   header: (struct), see http_createHeader
            %
            %   PARAMETERS USED:
            %   oauth.opt_http_param_encoding_option
            %
            %   See Also:
            %   http_paramsToString
            %   oauth.make_basic_url_request
            
            
            [str,header] = http_paramsToString(obj.params,obj.parent.opt_http_param_encoding_option);
        end
    end
    
    %NOTE: These functions are different from the static methods
    %as they check if the operation is desired or not ...
    methods (Hidden)
        function params = processNewParams(obj,params)
            %processNewParams Runs through all possible manipulations of new parameters
            %
            %   params = processNewParams(obj,params)
            %
            %   NOTE: This is the primary gateway for manipulation of input
            %   parameters. It calls several helper functions which do the
            %   actual work. In addition the parameters
            %
            %   INPUT
            %   ===========================================
            %   params: see object description
            %
            %   OUTPUT
            %   ===========================================
            %   params: after possible manipulation
            %

            %
            %   See Also:
            %   processEmptyParams
            %   processNumericParams
            %   processUnicodeParams
            
            
            params = processEmptyParams(obj,params);
            params = processNumericParams(obj,params);
            params = processUnicodeParams(obj,params);
        end
        function params = processUnicodeParams(obj,params)
            if obj.parent.opt_convert_params_to_utf8
                params = oauth_params.convertStringsToUTF8(params);
            end
        end
        function params = processEmptyParams(obj,params)
            %processEmptyParams Handles removal of empty params
            %
            %   processEmptyParams(obj)
            %
            %   Uses parent's property: opt_allow_empty_oauth_params
            %   Calls: removeEmptyParams
            if ~obj.parent.opt_allow_empty_oauth_params
                params = oauth_params.removeEmptyParams(params);
            end
        end
        function params = processNumericParams(obj,params)
            %%%if ~obj.cast_numbers_to_strings, return; end
            if obj.parent.opt_cast_numbers_to_strings
                params = oauth_params.convertNumbersToStrings(params,obj.parent.opt_number_to_string_fhandle);
            end
        end
    end
    
    %==================================================================
    %                       STATIC METHODS
    %==================================================================
    methods (Static)
        normParams = normalizeParams(params) %External file
        function [isGood,str]  = verifyParams(params,throwError,varargin)
            %verifyParams  Verifies that parameter data is ok
            %
            %   [isGood,str]  = verifyParams(params)
            %
            %   CURRENT VERIFICATION STEPS
            %   - input data type
            %   - must be a vector
            %   - must have even length
            
            in.allow_numerics = true;
            in = processVarargin(in,varargin);
            
            
            isGood = true;
            str = '';
            if ~isempty(params)
                if in.allow_numerics
                    if ~iscellstr(params(1:2:end))
                        isGood = false;
                        str = 'Properties names are not all strings';
                    end
                else
                    if ~iscellstr(params)
                        isGood = false;
                        str = 'Input is not cellstr';
                    end
                end
                if ~isGood
                    error(str)
                else
                    return
                end
            end
            if numel(params) ~= length(params)
                isGood = false;
                str = 'Params must be a vector, not a matrix';
                if throwError
                    error(str)
                else
                    return
                end
            end
            
            if mod(length(params),2) ~= 0
                isGood = false;
                str = 'Params must come in property/value pairs';
                if throwError
                    error(str)
                else
                    return
                end
            end
        end
        function params = removeEmptyParams(params)
            %removeEmptyParams Removes empty parameters
            %
            %   paramsProcess = removeEmptyParams(paramsProcess)
            
            if isempty(params), return; end
            
            delMask  = false(1,length(params));
            for iParam = 2:2:length(params)
                if isempty(params{iParam})
                    delMask(iParam-1:iParam) = true;
                end
            end
            params(delMask) = [];
        end
        function params = convertNumbersToStrings(params,convFunction)
            %convertNumbersToStrings Convert numeric values to strings
            %
            %   paramsProcess = convertNumbersToStrings(paramsProcess,convFunction)
            %
            %   INPUTS
            %   =======================================================================
            %   paramsProcess : cell array of property/value pairs
            %   convFunction  : (function handle), function to evalute in
            %                   converting # to string
            
            
            if isempty(params), return; end
            
            assert(iscell(params),'Parameters for numeric conversion should be passed in as a cell if not empty')
            
            for iParam = 2:2:length(params)
                if isnumeric(params{iParam})
                    params{iParam} = feval(convFunction,params{iParam});
                end
            end
        end
        function params = convertStringsToUTF8(params)
            %convertStringsToUTF8 Converts all property and value strings to UTF-8
            %
            %   paramsProcess = convertStringsToUTF8(paramsProcess)
            
            params(cellfun('isclass',params,'char')) = ...
                cellfun(@(x) char(unicode2native(x)),params(cellfun('isclass',params,'char')),'un',0);
        end
        function params = fixForwardSlash(params)
            %fixForwardSlash Encodes forward slash as %2F
            %
            %   JAH TODO: Add on documentation ...
            %
            %   paramsProcess = fixForwardSlash(paramsProcess)
            %
            %
            
            for iParam = 1:length(params)
                if ischar(params{iParam})
                    params{iParam} = regexprep(params{iParam},'/','%2F');
                end
            end
        end
    end
    
    methods (Hidden, Access = private)
        function setParameter(obj,property,value)
            %setParameter Sets a parameter by either
            %
            %    params = setParameter(params,property,value)
            %
            %    Final method for adding on extra parameters
            
            %KNOWN CALLERS:
            %    addParams
            %    mergeParams
            %    addOauthSignature
            
            I = find(strcmp(obj.params(1:2:end),property));
            if length(I) > 1
                error('Unable to update property: %s, as it occurs multiple times: %d',property,length(I))
            end
            
            if ~isempty(I)
                obj.params{2*I} = value;
            else
                obj.params = [obj.params property value];
            end
        end
    end
    
end

