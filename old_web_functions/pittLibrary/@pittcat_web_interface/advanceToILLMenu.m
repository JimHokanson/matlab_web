function [web_page_text,prev_url] = advanceToILLMenu(pcat_user)
%
%
%   [web_page_text,prev_url] = advanceToILLMenu(pcat_user)
%
%   INPUTS
%   ==================================
%   pcat_user : (class pittcat_user)
%
%   class: pittcat_web_interface

ILL_URL        = 'http://clioserver.library.pitt.edu/clioweb/Inside/Menu.cfm';
LOGIN_TEXT     = 'Please log in with';

[web_page_text,extras] = urlread2(ILL_URL);

if ~isempty(strfind(web_page_text,LOGIN_TEXT))
    %LOGIN - probably should move to separate method
    form = form_get(web_page_text,ILL_URL);
    form = form_helper_setTextValue(form,'username',pcat_user.pcat_u);
    form = form_helper_setTextValue(form,'password',pcat_user.pcat_p);
    [web_page_text,extras] = form_submit(form);
end

prev_url = extras.url;
