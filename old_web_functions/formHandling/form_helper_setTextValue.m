function formStruct = form_helper_setTextValue(formStruct,name,value,varargin)
%form_helper_setTextValue  Sets a text field in a form
%
%   formStruct = form_helper_setTextValue(formStruct,name,value,varargin)
%
%   NOTE: Implements max length restriction if present
%
%   INPUTS
%   =======================================================================
%   formStruct : (structure), see form_get
%   name       : (string), name of the text field to set
%   value      : (string), value to set the field to
%                   IMPORTANT: Value must be a string
%
%   IMPROVEMENTS
%   =======================================================================
%   1) Allow name to be a property value pair for setting multiple values
%   easier instead of calling this function many times
%
%   See Also:
%       form_get
%       form_submit


%pvStruct -> property/value structure
%NOTE: pvStruct is for passwords and text boxes
%pvStruct2 is for hidden text fields and shouldn't be modified ->
%although I've found cases in which it is fine to do so ...

%JAH TODO: Cleanup this function

in.use_hidden = false;
in = processVarargin(in,varargin);

if nargin < 3
    error('Incorrect # of inputs') 
end

if in.use_hidden
    error('use_hidden is no longer being used, update code')
end

if length(formStruct) ~= 1
    error('The length of formStruct must be 1, select the form to use')
end

%1:3
%1, text & passwords
%2, hidden
%3, text_area
for iTry = 1:3
    switch iTry
        case {1 2}
            if iTry == 1
                fName = 'pvStruct';
            else
                fName = 'pvStruct2';
            end
            if isempty(formStruct.input.(fName))
                I_replace = [];
            else
                names = {formStruct.input.(fName)(:).name};
                I_replace = find(strcmp(names,name));
            end
        case {3}
            names = {formStruct.taTags.name};
            I_replace = find(strcmp(names,name));
    end
    
    for i_fix = 1:length(I_replace)
        if iTry == 3
            temp = formStruct.taTags(I_replace(i_fix));
        else
            temp = formStruct.input.(fName)(I_replace(i_fix));
        end
        %NOTE: Should have maxLength, check ta, change this 
        %after ensuring it in form_get
        if isfield(temp,'maxLength') && ~isempty(temp.maxLength)
            maxLength = str2double(temp.maxLength);
            if length(value) > maxLength
                value = value(1:maxLength);
            end
        end
        if iTry == 3
            formStruct.taTags(I_replace(i_fix)).value = value;
        else
            formStruct.input.(fName)(I_replace(i_fix)).value = value;
        end
    end
    
    if ~isempty(I_replace)
        break
    elseif iTry == 3
        error('Unable to set specified text box')
    end
end