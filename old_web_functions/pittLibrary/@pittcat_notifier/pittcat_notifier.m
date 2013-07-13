classdef pittcat_notifier < handle
    %pittcat_notifier
    
    properties
       gui_obj
       verbose = false; %Nothing done with this currently ...
    end
    
    methods(Access=private)
        function obj = pittcat_notifier()
            % initialize object
        end
    end
    
    methods (Hidden, Static)
        function obj = getReference()
            % Creates the NotifierManager if it does not already exist.
            % Returns the unique instance of NotifierManager
            persistent ref;
            if isempty(ref)
                obj = pittcat_notifier();
                ref = obj;
            else
                obj = ref;
            end
        end
    end
    
    methods (Static)
        
        function clear(varargin)
           obj = pittcat_notifier.getReference;
           if isobject(obj.gui_obj)
              clearStatus(obj.gui_obj) 
           end
        end
        
        function error(varargin)
           obj = pittcat_notifier.getReference;
           if isobject(obj.gui_obj)
              setNotifier(obj.gui_obj,'error',varargin{:})
           else
              error(varargin{:})
           end
        end
        
        function warning(varargin)
           obj = pittcat_notifier.getReference;
           if isobject(obj.gui_obj)
               setNotifier(obj.gui_obj,'warning',varargin{:})
           else
               
           end
        end
        
        function status(varargin)
           obj = pittcat_notifier.getReference;
           if isobject(obj.gui_obj)
              setNotifier(obj.gui_obj,'status',varargin{:}) 
           else
               
           end
        end
        
        function init(gui_obj,verbose)
            obj = pittcat_notifier.getReference;
            obj.gui_obj = gui_obj;
            if exist('verbose','var')
               obj.verbose = verbose; 
            end
        end
        
        function setVerbose(value)
            obj = pittcat_notifier.getReference;
            obj.verbose = value;
        end
    end
    
end

