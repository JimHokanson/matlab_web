classdef pittcat_journal_lib_has_match < handle
    %pittcat_journal_lib_has_match
    %
    %   Object documents the properties of matching a journal object
    %   to a library holding object
    %
    %   See Also:
    %
    
    properties
        goodVolume   = false
        goodYear     = false
        followsRules = true
        yearDiff     = NaN
    end
    
    properties (Dependent)
        match_type
    end
    
    methods
        function value = get.match_type(obj)
            if obj.goodVolume && obj.goodYear
                value = 2;
            elseif obj.goodVolume
                value = 1;
            else
                value = 0;
            end
        end
    end
    
    methods
        function objs = pittcat_journal_lib_has_match(lib_has_objs,j_obj)
            if nargin == 0
                return
            end
            
            nObjs       = length(lib_has_objs);
            objs(nObjs) = pittcat_journal_lib_has_match;
            for iObj = 1:nObjs
                checkVolumeAndYear(objs(iObj),lib_has_objs(iObj),j_obj);
            end
            
        end
    end
    
end

