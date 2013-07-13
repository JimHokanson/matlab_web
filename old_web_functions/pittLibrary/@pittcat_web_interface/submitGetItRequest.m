function [success,extras] = submitGetItRequest(web_page_text,prev_url,j_obj,varargin)
%
%
%   

GOOD_REQUEST_TEXT   = 'Your Get It! request was successful!';

in.pick_up = false;
in = processVarargin(in,varargin);

if in.pick_up
    error('Not yet implemented')
end

%NOW ONTO FILLING OUT THE FORM
%---------------------------------------------------------------
curForm = form_get(web_page_text,prev_url);
%specify an issue - radio:CVAL:'1'
%specify article title -> FF0
%specify vol/year/pages -> FF1 
%article author -> FF2

curForm = form_helper_selectRadio(curForm,'CVAL','1');
curForm = form_helper_setTextValue(curForm,'FF0',j_obj.title);
volYearPages = sprintf('%s / %s / %s',j_obj.volume,j_obj.year,j_obj.pages);
curForm = form_helper_setTextValue(curForm,'FF1',volYearPages);
authorsStr = cellArrayToString(j_obj.authors,' : ');
curForm = form_helper_setTextValue(curForm,'FF2',authorsStr);

[web_page_text,extras] = form_submit(curForm);

extras.raw = web_page_text;

success = ~isempty(strfind(web_page_text,GOOD_REQUEST_TEXT));