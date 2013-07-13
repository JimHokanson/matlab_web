function [web_page_text,prev_url] = loginIfNeeded(web_page_text,prev_url,pcat_user)
%loginIfNeeded
%   
%   [web_page_text,prev_url] = loginIfNeeded(web_page_text,prev_url,pcat_user)
%
%   JAH TODO: Document function

UNSUCCESSFUL_LOGIN = 'Unsuccessful Authentication';

if pittcat_web_interface.checkIfLoginIsNeeded(web_page_text)
    formStruct = form_get(web_page_text,prev_url);
    curForm = formStruct(1);
    curForm = form_helper_setTextValue(curForm,'ext_id',pcat_user.pcat_u);
    curForm = form_helper_setTextValue(curForm,'ext_pw',pcat_user.pcat_p);
    [web_page_text,extras] = form_submit(curForm);
    prev_url = extras.url; 
    
    if ~isempty(strfind(web_page_text,UNSUCCESSFUL_LOGIN))
        error('Unable to login')
    end
end