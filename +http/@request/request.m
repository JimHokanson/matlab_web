classdef request < sl.obj.handle_light
    %
    %   Class:
    %   http.request
    %
    %
    %   What features should this class have?
    %
    %   - cookies support?
    %
    %
    %
    %   Can a request come from a session with in memory cookies?
    %
    %   How does requests do this?
    
    
    %TODO: A request should store the specific information about a request
    properties
       method  = 'GET';
       body    = '';
       headers
       options  %When will this be set ??????
    end
    
    properties (Hidden)
       depth = 0 %This is used to keep track of the # of redirects the code has followed.  
    end
    
    methods
    end
    
end

