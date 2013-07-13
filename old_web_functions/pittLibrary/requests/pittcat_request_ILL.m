function success = pittcat_request_ILL(docStruct)
%pittcat_request_ILL
%
%   Might need to split into parts, other options might be useful
%
%   TODO
%   1) Document function
%   2) Break into subfunctions????
%   3) Expose more options? -> view requests, etc?
%
%   ILL INTERFACE
%   ===========================================
%   1) LOGIN
%   2) Choose option - view current requests or submit new request
%   3) If submitting a new request, choose option - loan or copy
%   4) Requesting a copy is implemented, not sure if a loan is different
%
%   NOTE: if I am logged in, I will get the menu, if not, I will be asked
%   to login
%
%   CURRENT STATUS:
%   ===========================================
%   this function works, but it needs to be broken up a bit
%   we need to be able to better identify the steps, and handle that
%   the functionality here might be needed elsewhere
%

%NOTE: This could be cleaned up with the form_submit function

%LOAN STEPS
%1) log in
%2) submit new request
%3) specify type -> loan or copy
%4) fill out form

ILL_URL = 'http://clioserver.library.pitt.edu/clioweb/Inside/Menu.cfm';


TIME_OUT_TEXT = 'Please log in with your University of Pittsburgh Computer Account';

REQUEST_OPTION = 2; %Submit new request -> view current requests, submit new request, logout
REQUEST_TYPE   = 2; %Copy  -> Loan, copy, return to main menu, log out
STATUS_OPTION  = 'graduate student';
GOOD_RESPONSE  = 'Your request has been sent to the ILL Office';
%bad response -> %There was a problem sending your request!

SUBMIT_FORM    = 1; %submit, return to main menu, log out

info = pittcat_getUserInfo;

%INITIAL LOGIN SCREEN
%==========================================================================
%-> make this a subfunction?????

[output,extras] = urlread2(ILL_URL,'get','',[]);

%MIGHT ALREADY BE LOGGED IN

form = form_get(output,ILL_URL);
if length(form) ~= 1
    url = ILL_URL;
else
    form = form_helper_setTextValue(form,'username',info.login.pcat_u);
    form = form_helper_setTextValue(form,'password',info.login.pcat_p);
    [output,extras] = form_submit(form);
    url = extras.url;
end

%OPTION SCREEN
%==========================================================================
%-> view your current requests
%-> submit a new request
form = form_get(output,url);
%1 - Results
%2 - Reqform
%3 - Logout

%Should check 1

%IMPORTANT: SINCE WE MAY SKIP THIS, WE MIGHT WANT TO RETURN TO THE MAIN
%MENU, IT WOULD BE USEFUL TO BREAK THESE UP INTO PARTS ...
if ~strcmpi(form(1).input.tags.value,'LOAN')
    formUse = form(REQUEST_OPTION);
    % formUse.input.tags -> 
    %      type: 'submit'
    %     value: 'Submit a NEW request'
    %      name: ''

    if ~strcmpi(formUse.input.tags.value,'Submit a NEW request')
        error('Unexpected form')
    end
    [output,extras] = form_submit(formUse);
end
%TYPE SCREEN -> loan or copy
%==========================================================================
form    = form_get(output,url);
formUse = form(REQUEST_TYPE); %specification of loan or copy
[output,extras] = form_submit(formUse);

%FILLING OUT THE MAIN FORM
%==========================================================================
form = form_get(output,url);
formUse = form(SUBMIT_FORM);
%TODO: verify 

%Should be filled in already
%-----------------------------------
%name
%email
%phone
%campus address

%Needs to be filled in
%------------------------------------------
%department -> 'department'
formUse = form_helper_setTextValue(formUse,'department',info.login.department);
%status -> 'status'
% - faculty
% - graduate student
% - undergraduate
% - staff
formUse = form_helper_selectOption(formUse,'status','value',STATUS_OPTION);
%university id # - "patronID"
formUse = form_helper_setTextValue(formUse,'patronID',info.login.twoP);


%journal title - "booktitle"
formUse = form_helper_setTextValue(formUse,'booktitle',docStruct.journal);
%volume - "volumenumber"
formUse = form_helper_setTextValue(formUse,'volumenumber',docStruct.volume);
%issue number - "articlenumber"
formUse = form_helper_setTextValue(formUse,'articlenumber',docStruct.issue);
%date - "articledate"
formUse = form_helper_setTextValue(formUse,'articledate',docStruct.year);
%pages - "pages"
formUse = form_helper_setTextValue(formUse,'pages',docStruct.pages);
%article author(s) - "articleauthor"
authorsTemp = cellArrayToString(docStruct.authors,', ');
formUse = form_helper_setTextValue(formUse,'articleauthor',authorsTemp);
%article title - "articletitle"
formUse = form_helper_setTextValue(formUse,'articletitle',docStruct.title);
%issn - "isbn_issn"
formUse = form_helper_setTextValue(formUse,'isbn_issn',docStruct.issn);
%not needed after date - "needbefore"
%Add six months
needBeforeDate = datestr(now + 6*30,'mm/dd/yy');
formUse = form_helper_setTextValue(formUse,'needbefore',needBeforeDate);

%notes - "Notes"
%NOT IMPLEMENTED

[output,extras] = form_submit(formUse); %#ok<ASGLU>

success = ~isempty(strfind(output,GOOD_RESPONSE));
