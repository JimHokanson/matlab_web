function [success,extras] = request_via_ILL(j_obj,pcat_user)
%
%   [success,extras] = pittcat_web_interface.request_via_ILL(j_obj,pcat_user)
%
%   class: pittcat_web_interface

%LOAN STEPS
%1) log in
%2) submit new request
%3) specify type -> loan or copy
%4) fill out form

ILL_MENU_OPTION = 2; %Submit new request -> view current requests, submit new request, logout
REQUEST_OPTION  = 2; %Copy  -> Loan, copy, return to main menu, log out
NEED_BEFORE_DATE = datestr(now + 6*30,'mm/dd/yy');
GOOD_RESPONSE  = 'Your request has been sent to the ILL Office';
SUBMIT_FORM    = 1; %three forms, submit, return to main menu, log out


pittcat_notifier.status('Logging In');
[web_page_text_1,prev_url_1] = pittcat_web_interface.advanceToILLMenu(pcat_user);

[web_page_text_2,prev_url_2] = pittcat_web_interface.selectILLOption(web_page_text_1,prev_url_1,ILL_MENU_OPTION);

pittcat_notifier.status('Obtaining ILL Form');
[web_page_text_3,prev_url_3] = pittcat_web_interface.chooseILLRequestOption(web_page_text_2,prev_url_2,REQUEST_OPTION);


%TYPE SCREEN -> loan or copy
%==========================================================================
form    = form_get(web_page_text_3,prev_url_3);
formUse = form(REQUEST_TYPE); %specification of loan or copy
[output,extras] = form_submit(formUse);

%FILLING OUT THE MAIN FORM
%==========================================================================
form    = form_get(output,url);
formUse = form(SUBMIT_FORM);

%CFForm_1 - name, verify

formUse = form_helper_selectOption(formUse,'status','value',STATUS_OPTION);

%Should be filled in already
%-----------------------------------
%name
%email
%phone
%campus address
%-------------------------------------
%notes - "Notes"
%NOT IMPLEMENTED
%-------------------------------------------
%class pittcat_user
%class journal_doc
temp = {...
    'department'        pcat_user.department
    'patronID'          pcat_user.twoP;
    'booktitle'         j_obj.journal
    'volumenumber'      j_obj.volume
    'articlenumber',    j_obj.issue
    'articledate',      j_obj.year
    'pages',            j_obj.pages
    'articleauthor',    j_obj.allAuthors
    'articletitle',     j_obj.title
    'isbn_issn',        j_obj.issn
    'needbefore',       NEED_BEFORE_DATE};

for iRow = 1:size(temp,1)
    formUse = form_helper_setTextValue(formUse,temp{iRow,1},temp{iRow,2});
end

[output,extras] = form_submit(formUse);

success = ~isempty(strfind(output,GOOD_RESPONSE));

if success
    pittcat_notifier.status('Document successfully requested Interlibrary Loan!');
else
    %NOTE: Not sure why this would happen ...
    pittcat_notifier.warning('Unable to retrieve document from Interlibrary Loan');
end
