function formStruct = form_helper_chooseButton(formStruct,buttonUse)
%form_helper_chooseButton
%
%   formStruct = form_helper_chooseButton(formStruct,buttonUse)
%
%   NOTE: If no button is selected, then the first button is used
%
%   INPUTS
%   =======================================================================
%   formStruct :
%   buttonUse  : # of the button to use, this must currently be done
%                by inspection of formStruct and the web page that is being
%                emulated
%
%   IMPROVEMENTS
%   =======================================================================
%   1) build in button selection based on some criteria
%
%   See Also:
%       form_get
%       form_submit
%       form_createRequest   

nButtons = length(formStruct.input.buttonOptions);

if nButtons >= buttonUse
    formStruct.input.buttonUse = buttonUse;
else
    error('Invalid buttonUse #: %d, only %d available',buttonUse,nButtons)
end
