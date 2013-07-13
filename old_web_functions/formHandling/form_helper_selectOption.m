function formStruct = form_helper_selectOption(formStruct,name_or_index,selectMethod,selectValue)
%form_helper_selectOption  Selects a check box
%
%   formStruct = form_helper_selectOption(formStruct,name_or_index,selectMethod,selectValue)
%
%   INPUTS
%   =======================================================================
%   formStruct     : (structure), see form_get
%   name_or_index  : name of the select form to modify
%   selectMethod   : how to select the option (case-insensitive matching)
%       - 'index'  - numeric value of option to choose
%       - 'value'  - match selectValue to value attribute of option
%       - 'data'   - match selectValue to data attribute of option (what's
%                       visible to the user, not hidden in the tag)
%   selectValue    : index value or value to match, depends on selectMethod
%
%   CASE INSENSITIVE MATCHING, PERFORMED USING STRCMPI
%
%   EXAMPLE
%   =======================================================================
%     <select class=car>
%       <option value="volvo">Volvo</option>
%       <option value="saab">Saab</option>
%       <option value="mercedes">Give me the Benz yo</option>
%       <option value="audi">Audi</option>
%     </select>
%
%   ...,'car','index',1)        %selects 'volvo'
%   ...,'car','value','saab')   %selects 'saab'
%   ...,'car','data','Benz yo') %selects 'mercedes'
%
%   See Also:
%   form_submit
%   form_get

if ischar(name_or_index)
    sl = formStruct.select;
    
    names = cell(1,length(sl));
    for i_sl = 1:length(sl)
        names(i_sl) = {sl(i_sl).att.name};
    end
    
    I_use = find(strcmp(names,name_or_index),1);
    if isempty(I_use)
        error('Name not found for select tag')
    end
else
    I_use = name_or_index;
end

optArray = sl(I_use).options;
switch lower(selectMethod)
    case 'index'
        I2_use = selectValue;
    case 'value'
        valueAll = {optArray.value};
        I2_use   = find(strcmpi(valueAll,selectValue),1);
    case 'data'
        dataAll = {optArray.data};
        I2_use   = find(strcmpi(dataAll,selectValue),1);
    otherwise
        error('Invalid selectMethod option')
end

if isempty(I2_use)
    error('Unable to find option match based on selectValue')
end

for i_Opt = 1:length(optArray)
    if i_Opt == I2_use
        formStruct.select(I_use).options(i_Opt).selected = 'selected';
    else
        formStruct.select(I_use).options(i_Opt).selected = '';
    end
end
