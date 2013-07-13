classdef pittcat_library_holding_journal < pittcat_library_holding
    %pittcat_library_holding_journal
    %
    %   Holdings information for journal. Each result page can 
    %   have multiple holdings, generally one for storage and another for
    %   content that is in the library
    %
    %   EXAMPLE OF REPRESENTED WEB TEXT:
    %   =============================================================
    %     Location:	 Falk Library - Periodicals - 200 Scaife Hall
    %     Call Number:	 None
    %     Status:	 Not Checked Out
    %     Library has:	 v.50-73(1990-1992)
    %                    v.75:no.3/4(1994)
    %                    v.76-116(1994-2006)
    %   
    %   METHODS:
    %   ===============================================
    %   doesHoldingMatchJournal
    
    properties
        lib_has_line_objs
    end
    
    methods
        function obj = pittcat_library_holding_journal(pittcat_result_page)
            if nargin == 0
                return
            end
            
            holding_struct = pittcat_result_page.gen_holding_struct;
            nObjs      = length(holding_struct);
            obj(nObjs) = pittcat_library_holding_journal;
            
            nObjs = length(obj);
            for iObj = 1:nObjs
                initObject(obj(iObj),pittcat_result_page,holding_struct(iObj))
                cur_h = obj(iObj).raw;  %raw structure, fields mean nothing yet to code
                %See pittcat_result_page.getGenericStructs
                if isfield(cur_h,'Library_has')
                    temp_ca = cur_h.Library_has.values;
                    if ~isempty(temp_ca)
                        obj(iObj).lib_has_line_objs  = pittcat_holding_library_has(temp_ca,obj(iObj));
                    end
                end
            end
        end
    end
    
end

