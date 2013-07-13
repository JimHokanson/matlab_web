classdef pittcat_web_interface
    %pittcat_web_interface
    
    properties (Constant)
       EXP_TEXT = 'Your PITTCat session has timed out';
    end
    
    methods (Static)
        function checkExpiration(web_str)
            %checkExpiration  Checks whether or not current session has expired
            %
            %   checkExpiration(web_str)

            I = strfind(web_str,pittcat_web_interface.EXP_TEXT);
            if ~isempty(I)
               error('Your PittCat session has expired') 
            end 
        end
        
        %ILL RELATED
        %================================
        [web_page_text,prev_url] = advanceToILLMenu(pcat_user)
        
        [web_page_text,prev_url] = selectILLOption(web_page_text,prev_url,ILL_MENU_OPTION);
        
        [web_page_text,prev_url] = chooseILLRequestOption(web_page_text,prev_url,REQUEST_OPTION);
        
        [success,extras] = request_via_ILL(j_obj,pcat_user)

        
        %ULS REQUESTS
        %=============================================================
        [web_page_text,prev_url] = loginIfNeeded(web_page_text,prev_url,pcat_user)
        
        flag = checkIfLoginIsNeeded(web_page_text)
        
        [web_page_text,prev_url] = advanceToGetItPage(pcat_user,get_it_url)
        
        [web_page_text,prev_url] = submitGetItOrRecallForm(web_page_text,prev_url,loc_obj,user_obj,varargin)
        
        [success,extras] = submitGetItRequest(web_page_text,prev_url,j_obj,varargin)
        
        [flag,nEntries] = isEntriesPage(raw_text)
        
        [headers,text_ca,links] = parseEntriesPage(web_page_text,prev_url,nEntries);

    end
    
end

