function [web_page_text,prev_url] = chooseILLRequestOption(web_page_text,prev_url,option)
%selectILLOption
%
%   [web_page_text,prev_url] = chooseILLRequestOption(pcat_user)
%
%   INPUTS
%   ==================================
%   option : 
%      - 1 , Request a Loan
%      - 2 , Request a Copy
%      - 3 , Return to Main Menu
%      - 4 , Log Out
%
%   class: pittcat_web_interface

form = form_get(web_page_text,prev_url);

%There are multiple forms
%One for each option above
%
%NOTE: All forms only have one input
%All examples:
%<input type="Submit" value="LOAN">
%<input type="Submit" value="COPY">
%<input type="Submit" value="Return to Main Menu">
%<input type="Submit" value="Log Out">

formUse = form(option);

%Verify numeric option
value_text = formUse.input.tags.value;

switch option
    case 1
        txt_find = 'LOAN';
    case 2
        txt_find = 'COPY';
    case 3
        txt_find = 'Return';
    case 4
        txt_find = 'Log';
    otherwise
        error('Invalid option')
end

if isempty(strfind(value_text,txt_find))
    error('Selected option doesn''t yield the assumed form, this is a code error (not user')
end
   
[web_page_text,extras] = form_submit(formUse);
prev_url = extras.url;