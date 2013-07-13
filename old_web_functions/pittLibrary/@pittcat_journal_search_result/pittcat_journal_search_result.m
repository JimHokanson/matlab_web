classdef pittcat_journal_search_result < handle
    %pittcat_journal_search_result
    %
    %   This class is meant to hold the outcome of a search
    %   in terms of trying to match a journal document
    
    properties
       parent        %(class pittcat_client_journal_search)
       holding       %class pittcat_library_holding_journal < pittcat_library_holding
       holding_match %pittcat_journal_holding_match
    end
    
    properties (Dependent)
       requesting_client
       location             %string of location
       is_match
       goal_volume
       goal_year
       goal_issn
    end
    
    properties
       j_obj
    end
    
    methods 
       
        function value = get.requesting_client(obj)
           value = obj.parent.parent; 
        end
        
        function value = get.is_match(obj)
           value = obj.holding_match.is_match; 
        end
        
        function value = get.goal_volume(obj)
           value = obj.j_obj.volume;
        end
        
        function value = get.goal_year(obj)
           value = obj.j_obj.year;
        end
        
        function value = get.goal_issn(obj)
           value = obj.j_obj.issn; 
        end
        
        function value = get.location(obj)
           if isobject(obj.holding)
              value = obj.holding.location.raw_text; 
           else
              value = []; 
           end
        end
    end
    
    methods
        function objs = pittcat_journal_search_result(holding_objs,j_obj,p_obj)
            if nargin == 0
                return
            end
            
            nObjs = length(holding_objs);
            objs(nObjs) = pittcat_journal_search_result;
            for iObj = 1:nObjs
                objs(iObj).parent  = p_obj;
                objs(iObj).holding = holding_objs(iObj);
                objs(iObj).j_obj   = j_obj;
                objs(iObj).holding_match = pittcat_journal_holding_match(holding_objs(iObj),j_obj);
            end
        end        
    end
    
end

