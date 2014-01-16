classdef options < sl.obj.handle_light
    %
    %   Class:
    %   http.request.options
    %
    %   Some of these might be header options. It would be nice to wrap a
    %   map container with an object for setting the headers ...
    %
    %   e.g. user_agent
    %
    
    properties
       cast_output      = true   %If true ...
       follow_redirects = true
       read_timeout     = 10000; 
       encoding         = ''
       use_cookies      = true
       
       %Hooks for type?
       %i.e. json parser
       %xml parser ...
       %
       %something like ...
       json_parser  %NYI
    end
    
    methods
        function obj = options
           obj.json_parser = http.response.parsers.json.default; %...
        end
    end
    
end

