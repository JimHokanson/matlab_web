function [url,method,params_values] = form_createRequest(formStruct,varargin)
%form_createRequest Creates variables needed to make a request for the form
%
%   [url,method,params_values] = form_createRequest(formStruct,buttonIndex)
%
%   NOTE: In general this function does not need to be called, instead
%   generally people should call form_submit
%
%   HTML 4 FORM SPECIFICATION
%   =======================================================================
%   http://www.w3.org/TR/html401/interact/forms.html#h-17.13
%
%   OUTPUTS
%   =======================================================================
%   url    : url to query
%   method : method based on form's action
%   params_values: (cellstr) property/value pairs to put into the query
%
%   INPUTS
%   =======================================================================
%   formStruct  : (structure) see form_get
%
%   See Also:
%     form_get
%     form_submit
%     form_helper_chooseButton
%     form_helper_selectCheckBox
%     form_helper_selectOption
%     form_helper_selectRadio
%     form_helper_setTextValue

DEFINE_CONSTANTS
ADD_BUTTON = true;
END_DEFINE_CONSTANTS

if isNestedField(formStruct,'input.buttonUse')
    buttonIndex = formStruct.input.buttonUse;
else
    buttonIndex = 1;
end

if length(formStruct) ~= 1
    error('Form input was not singular')
end

%FORM HANDLING
%==========================================================================
form = formStruct.form;

%MADE ABSOLUTE IN GET METHOD ...
% if ~isempty(strfind(form.action,':'))
    %Then absolute
    url = form.action;
% else
%     jsoup_doc = formStruct.jsoup_doc;
%     url = 
%     url = url_getAbsoluteUrl(formStruct.url,form.action);
% end

if isfield(form,'method')
    method = upper(form.method);
else
    method = 'GET';
end

%See optional attributes: http://www.w3schools.com/tags/tag_form.asp

%??? -> what do you do when you post but your action has a query???
%does the query go in the url or get put into the body?
%-> Fiddler puts in the url

params_values = {};
order         = [];
%SELECT HANDLING
%--------------------------------------------
selectTags = formStruct.select;
if ~isempty(selectTags)
    for i_select = 1:length(selectTags)
        curSel     = selectTags(i_select);
        if ~isfield(curSel.att,'name')
            continue
        end
        curOptions = curSel.options;
        
        %NOTE: There might not exist any options
        if isempty(curOptions)
            continue
        end
        I_Select = find(~cellfun('isempty',{curOptions.selected}),1);
        if isempty(I_Select)
            I_Select = 1;
        end
        temp          = {curSel.att.name curOptions(I_Select).value};
        params_values = [params_values  temp];
        order         = [order curSel.start_location];
    end
end

input = formStruct.input;

%RADIO BUTTON HANDLING
%--------------------------------------------
rg = input.radioGroups;
if ~isempty(rg)
    for i_radio = 1:length(rg)
        I_Radio = find(~cellfun('isempty',rg(i_radio).checked));
        if isempty(I_Radio)
            I_Radio = 1;
        end
        temp            = [{rg(i_radio).name} rg(i_radio).values{I_Radio}];
        params_values   = [params_values  temp];
        order           = [order rg(i_radio).start_location];
    end
end

%CHECK BOX HANDLING
%----------------------------------------------
co = input.checkOptions;
if ~isempty(co)
    for i_co = 1:length(co)
        if ~isempty(co(i_co).isChecked)
            params_values = [params_values  {co(i_co).name co(i_co).value}];
            order         = [order co(i_co).start_location];
        end
    end
end

%TEXT HANDLING
%----------------------------------------------
pv = input.pvStruct; %Property, Value
for i_pv = 1:length(pv)
    params_values = [params_values  {pv(i_pv).name pv(i_pv).value}];
    order         = [order pv(i_pv).start_location];
end

%TEXT AREA HANDLING
%-----------------------------------------------
pv = formStruct.taTags; %Property, Value
for i_pv = 1:length(pv)
    params_values = [params_values  {pv(i_pv).name pv(i_pv).value}];
    order         = [order pv(i_pv).start_location];
end


%HIDDEN VALUES
%=============================================
pv2 = input.pvStruct2; %Property, Value
for i_pv2 = 1:length(pv2)
    params_values = [params_values  {pv2(i_pv2).name pv2(i_pv2).value}];
    order         = [order pv2(i_pv2).start_location];
end

bo = input.buttonOptions;
%BUTTON HANDLING
%-----------------------------------------------
if ADD_BUTTON
params_values = [params_values  {bo(buttonIndex).name bo(buttonIndex).value}];
order         = [order bo(buttonIndex).start_location];
end

%Remove empty names parameters

emptyNameIndices = find(cellfun('isempty',params_values(1:2:end)));

if ~isempty(emptyNameIndices)
    params_values([2*emptyNameIndices - 1 2*emptyNameIndices]) = [];
    order(emptyNameIndices) = [];
end

%Make everything strings for encoding ...
params_values(cellfun('isempty',params_values)) = {''};

%Reorder everything
[~,I] = sort(order);
nameIndices  = 2*I-1;
valueIndices = 2*I;
params_values_new = params_values;
params_values_new(1:2:end) = params_values(nameIndices);
params_values_new(2:2:end) = params_values(valueIndices);
params_values = params_values_new;

end