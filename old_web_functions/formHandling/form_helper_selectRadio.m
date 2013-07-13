function formStruct = form_helper_selectRadio(formStruct,name_or_index,value_or_index)
%form_helper_selectRadio  Selects a radio option
%
%   formStruct = form_helper_selectRadio(formStruct, name_or_index, value_or_index)
%
%   INPUTS
%   ==================================
%   formStruct    : (structure), see form_get
%   name_or_index : name of radio group to modify or the index of the group
%                   to modify
%   value_or_index: name of the value of the group to select, or the index
%                   in the group to select
%
%   ONLY ONE BUTTON CAN BE SELECTED
%
%   See Also:
%   form_get
%   form_submit

if ischar(name_or_index)
    names = {formStruct.input.radioGroups.name};
    radioIndex = find(strcmp(names,name_or_index),1);
    if isempty(radioIndex)
        error('Name not found for radio group')
    end
else
   radioIndex = name_or_index;
end

tempGroup = formStruct.input.radioGroups(radioIndex);

if ischar(value_or_index)
    names = tempGroup.values;
    valueIndex = find(strcmp(names,value_or_index),1);
    if isempty(valueIndex)
        error('Value not found for radio values')
    end
else
    valueIndex = value_or_index;
end

tempGroup.checked = repmat({''},1,length(tempGroup.checked));
tempGroup.checked(valueIndex) = {'checked'};

formStruct.input.radioGroups(radioIndex) = tempGroup;

