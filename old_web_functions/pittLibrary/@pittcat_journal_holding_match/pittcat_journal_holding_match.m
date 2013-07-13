classdef pittcat_journal_holding_match
    %pittcat_journal_holding_match
    %
    %   This class should determine if a holding holds the j_obj desired
    %   
    %   Currently the main way of determining this is to look at the
    %   "library has" line. In the future other parts of the holding might
    %   be important as well
    
    
    properties
       lib_has_matches
       holding
       match_type %0,no 1, maybe, 2 yes
       
    end
    
    properties (Hidden)
       lib_has_match_index 
    end
    
    properties (Dependent)
        is_match
        lib_has_best_match
        lib_has_match_line
    end
    
    methods
        function value = get.is_match(obj)
           value = obj.match_type > 0; 
        end
        function value = get.lib_has_best_match(obj)
           if isempty(obj.lib_has_match_index)
               value = [];
           else
               value = obj.lib_has_matches(obj.lib_has_match_index);
           end
        end
        function value = get.lib_has_match_line(obj)
           if isempty(obj.lib_has_match_index)
               value = [];
           else
               value = obj.holding.lib_has_line_objs(obj.lib_has_match_index).raw_text;
           end 
        end
    end
    
    methods
        function obj = pittcat_journal_holding_match(holding_obj,j_obj)
            %pittcat_journal_holding_match
           obj.holding = holding_obj;
           obj.lib_has_matches = pittcat_journal_lib_has_match(holding_obj.lib_has_line_objs,j_obj);
           
           %Determine if 
           
           tempMatchTypes = [obj.lib_has_matches.match_type];
           if any(tempMatchTypes == 2)
               I = find(tempMatchTypes == 2);
           elseif any(tempMatchTypes == 1)
              followsRules   = [obj.lib_has_matches.followsRules];
              if all(followsRules)
                 I = find(tempMatchTypes == 1); 
              else
                 I = [];
                 %? Show warning ????
              end
           else
              I = []; 
           end
           
           if length(I) > 1
                   error('A valid match should only occur for one "Library Has" line, see code')
           end
           
           if isempty(I)
               obj.match_type = 0;
               obj.lib_has_match_index = [];
           else
               obj.match_type = tempMatchTypes(I);
               obj.lib_has_match_index = I;
           end
           
           
        end
    end
    
end

