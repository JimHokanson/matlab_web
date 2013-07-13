function [web_page_text_out,prev_url_out] = submitGetItOrRecallForm(web_page_text_in,prev_url_in,loc_obj,user_obj,varargin)
%submitGetItOrRecallForm
%
%
%   [web_page_text,prev_url] = submitGetItOrRecallForm(web_page_text,prev_url,loc_obj,user_obj,varargin)
%
%   See photo: getItOrRecall_Page.jpg


in.option = 'get_it'; %recall
in = processVarargin(in,varargin);

FAILURE_GET_PAGE    = 'You are not authorized to place a request for this item';

%1) Recall
%2) Get it

switch in.option
    case 'get_it'
        index_value = 2;
    case 'recall'
        index_value = 1;
    otherwise
        error('Unrecognized option')
end

curForm = form_get(web_page_text_in,prev_url_in);
curForm = form_helper_selectOption(curForm,'REQPICK','index',index_value);
[web_page_text_out,extras] = form_submit(curForm);

prev_url_out = extras.url;

if ~isempty(strfind(web_page_text_out,FAILURE_GET_PAGE))
    %Did this in Chrome it worked, then 
    %took the address from Chrome and did again
    %in Matlab and it worked, what the heck ???
    
    %pittcat_client.show_page(web_page_text_out)
    %pittcat_client.show_page(web_page_text_in)
    %JAH TODO:  use these loc_obj,user_obj
    error('WTF!') %Is this for trying with hsls???
end
