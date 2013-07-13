%{

1) In startup, call the function:
    install_JSOUP

2) Certificate processing:
For now see:
http://www.mathworks.com/matlabcentral/answers/39563-managing-public-key-certificates-in-matlab

Ideally I could improve this process

3) Constants file updates
C.TOOLBOXES_LOAD_ON_START   : add 'webFunctions'
C.LIBRARY_INFO_ROOT         : define this, this will be a dump site for
certain things and also where some user info is stored

%JAH TODO: Describe what gets saved there

4) Populate the Pittcat user file:

%JAH TODO: Need gui

twoP
lastName
requestor
email
department
pcat_p
pcat_u
is_uls
is_hsls



%}