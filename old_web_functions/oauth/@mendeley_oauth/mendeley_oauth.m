classdef mendeley_oauth < oauth
%mendeley_oauth
    
    properties (Constant, Hidden)
        REQUEST_URL = 'http://www.mendeley.com/oauth/request_token/';
        AUTH_URL    = 'http://www.mendeley.com/oauth/authorize/';
        ACCESS_URL  = 'http://www.mendeley.com/oauth/access_token/';
    end
    
    methods
        
        function obj = mendeley_oauth(varargin)
           obj = obj@oauth(varargin{:});
        end

    end
    
    methods (Static)
        access_token_example(consumer_key,consumer_secret)
    end
end

