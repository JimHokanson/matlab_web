function [web_page_text,prev_url] = selectILLOption(web_page_text,prev_url,option)
%selectILLOption
%
%   [web_page_text,prev_url] = selectILLOption(web_page_text,prev_url,option)
%
%   INPUTS
%   ==================================
%   option : 
%      - 1 , view current requests
%      - 2 , submit a new request
%      - 3 , logout
%
%   class: pittcat_web_interface

form = form_get(web_page_text,prev_url);

%There are multiple forms
%1) View Current Requests
%2) Submit a New Request
%3) Log Out
%NOTE: All forms only have one input
%All examples:
%<input type="submit" value="View your CURRENT requests">
%<input type="submit" value="Submit a NEW request">
%<input type="submit" value="Log Out">

formUse = form(option);

%Verify numeric option
value_text = formUse.input.tags.value;

switch option
    case 1
        txt_find = 'CURRENT';
    case 2
        txt_find = 'NEW';
    case 3
        txt_find = 'Log';
    otherwise
        error('Invalid option')
end

if isempty(strfind(value_text,txt_find))
    error('Selected option doesn''t yield the assumed form, this is a code error (not user')
end
    
[web_page_text,extras] = form_submit(formUse);
prev_url = extras.url;