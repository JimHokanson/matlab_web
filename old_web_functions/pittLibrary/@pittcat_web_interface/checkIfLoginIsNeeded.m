function flag = checkIfLoginIsNeeded(web_page_text)

LOGIN_TEXT = 'If you are unable to login, contact the Hillman Library';

flag = ~isempty(strfind(web_page_text,LOGIN_TEXT));