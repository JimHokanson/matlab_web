function [web_page_text,prev_url] = advanceToGetItPage(pcat_user,get_it_url)
%
%   [web_page_text,prev_url] = advanceToGetItPage(pcat_user,get_it_url)
%
%

DOCUMENT_MOVED_TEXT      = 'The document has moved';
REDIRECT_LOGIN_PAGE_TEXT = '<FORM name="logonpage"';

%Following the "Get It" Link
%--------------------------------------------
[web_page_text,extras] = urlread2(get_it_url);

%JAH TODO: If expired, go back to page, too bad there is no static entry ...
%i.e. the link has a session id in it, would need to research again
%not sure if anything on the page uniquely identifies it ...

pittcat_web_interface.checkExpiration(web_page_text);

prev_url = extras.url;

%Weird redirection request ... :/
if ~isempty(strfind(web_page_text,REDIRECT_LOGIN_PAGE_TEXT))
    get_it_url     = deref(regexp(web_page_text,'window\.location="([^"].*)"','tokens','once'));
    [web_page_text,extras]  = urlread2(get_it_url);
    prev_url = extras.url;
end

[web_page_text,prev_url] = pittcat_web_interface.loginIfNeeded(web_page_text,prev_url,pcat_user);

%Why would it move??? Were we not following redirects ????
if ~isempty(strfind(web_page_text,DOCUMENT_MOVED_TEXT))
   get_it_url = deref(regexp(web_page_text,'href="([^"].*)"','tokens','once'));
   get_it_url = html_encode_decode_amp('decode',get_it_url);
   web_page_text = urlread2(get_it_url);
   prev_url = get_it_url;
end