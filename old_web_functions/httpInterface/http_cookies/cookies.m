classdef cookies < handle
    % Ideas of things to implement
    % < singleton_class
    % < singleton_GUI_class
    %
    %http://docs.oracle.com/javase/tutorial/networking/cookies/cookiemanager.html  

    
    properties (Dependent)
       current_cookie_manager
       cookie_store
       stored_URIs
    end
    
    properties (Hidden)
       % 
       default_cookie_manager 
    end
    
    methods 
        function value = get.stored_URIs(obj)
            if ~isempty(obj.cookie_store)
               value = obj.cookie_store.getURIs; 
            else
               value = [];
            end
        end
        
        function value = get.cookie_store(obj)
           if ~isempty(obj.current_cookie_manager)
               value = obj.current_cookie_manager.getCookieStore;
           else
               value = [];
           end
        end
        
        function value = get.current_cookie_manager(~) 
           value = java.net.CookieHandler.getDefault; 
        end
    end
    
    methods (Access = private)
        function obj = cookies 
           initManager(obj) 
        end
        
        function initManager(obj)
            %http://bugs.sun.com/view_bug.do?bug_id=6349566
            %No protection, same domain bug ...
            %Should implement our own Cookie Policy, if only 
            %we could change the map ...
            
            obj.default_cookie_manager = java.net.CookieManager();
            %This is the questionable part ...
            obj.default_cookie_manager.setCookiePolicy(java.net.CookiePolicy.ACCEPT_ALL)
            java.net.CookieHandler.setDefault(obj.default_cookie_manager); 
        end
        
    end
    
    methods (Static, Access = private) 
        function my_obj_out = obj
            
           persistent my_obj
           
           if isempty(my_obj)
              my_obj = cookies;
           end
           
           my_obj_out = my_obj;
           
        end
    end
    
    
    methods (Static)
        
        function debug
           obj = cookies.obj;
           disp(createLinkForCommands('Click here','goDebug'));
           keyboard
        end
        
%         function value = set(urlConn)
%            obj = cookies.obj; 
%            keyboard
%         end
        
%         function value = get(URI)
%            obj = cookies.obj;
%            value = obj.cookie_store.get(URI);
%         end
%         
        function props
           obj = cookies.obj;
           disp(obj); 
        end
        
        function enable
           obj = cookies.obj;
           java.net.CookieHandler.setDefault(obj.default_cookie_manager);
%            if isempty(obj.current_cookie_manager)
%               java.net.CookieHandler.setDefault(obj.default_cookie_manager);
%            end
        end
        
        function disable
           java.net.CookieHandler.setDefault([]); 
        end
    end
    
end

