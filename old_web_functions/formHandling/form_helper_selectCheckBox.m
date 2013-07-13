function formStruct = form_helper_selectCheckBox(formStruct,name_or_index,selectFlag)
%form_helper_selectCheckBox  Selects a check box
%
%   formStruct = form_helper_selectCheckBox(formStruct, name_or_index, selectFlag)
%
%   INPUTS
%   ======================================================
%   formStruct    : (structure) see form_get
%   name_or_index : name of the check box to modify
%   selectFlag    : (whether to make true or false)
%
%   See Also:
%   form_get
%   form_submit

if ischar(name_or_index)
    names = {formStruct.input.checkOptions.name};
    checkIndex = find(strcmp(names,name_or_index),1);
    if isempty(checkIndex)
        error('Name not found for checkbox')
    end
else
   checkIndex = name_or_index;
end

if selectFlag
    formStruct.input.checkOptions(checkIndex).isChecked = 'checked';
else
    formStruct.input.checkOptions(checkIndex).isChecked = '';
end
