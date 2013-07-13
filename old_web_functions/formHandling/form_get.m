function [output,extras] = form_get(web_url,origURL)
%form_get  Returns forms in a web page for help in building a request
%
%   formStruct = form_get(web_url)
%
%   formStruct = form_get(web_text,origURL);
%
%   formStruct = form_get(jsoup_document)
%
%   INPUTS
%   =======================================================================
%   web_url: full url of web page that has the form to process
%
%   OUTPUTS
%   =======================================================================
%   formStruct: (structure array, 1 for each form on the page, usually only 1)
%       .id     - this can be ignored
%       .url    - url passed into this function (for later use)
%       .form   - attributes of the form tag
%       .select - (structure array, 1 for each select tag in the form)
%           .att - attributes of the form tag
%               .name - main attribute of select, used for building request
%               ?? - other fields may exist
%           .options (structure array, 1 for each option in the select tag)
%               .value - a value to select, used for building request
%               .data  - the text displayed for that option
%               ?? - other attributes may exist
%       .input - (structure)
%
%   extras: (structure)
%       .web_text - text returned from web request
%       .allHeaders - headers, may be empty if text was passed in instead of url
%
%
%   NOTE: Currently there are a few form tags that are ignored, such as
%   buttons, legends, and labels.  File handling in a form is also
%   currently not supported.  Everything that is needed to build a request
%   should be returned in this function.
%
%   IMPROVEMENTS
%   =======================================================================
%   - add on read only? -> does this mean don't submit it??? -> in general
%   yes, unless dynamically set via a script not to be
%   - Grab text that is in same <tr> if in table - gives context to the text fields
%   - I search for form elements twice, reduce this to once, I added the
%   2nd set unepectedly when I couldn't accurately pull out the appearance
%   order, remove this redundancy ...
%
%   See Also:
%       jsoup_get_doc
%       form_createRequest
%       form_helper_chooseButton
%       form_helper_selectCheckBox
%       form_helper_selectOption
%       form_helper_selectRadio
%       form_helper_setTextValue
%       form_submit

if nargin == 2
    data = web_url;
    prev_url = origURL;
    d = jsoup_get_doc(data,prev_url);
elseif isjava(web_url)
    d = web_url;
else
    [data,extras] = urlread2(web_url);
    prev_url = extras.url;
    d = jsoup_get_doc(data,prev_url);
end

b = d.body;
form_tags = b.getElementsByTag('form');

nForms = form_tags.size;

output = struct('id',num2cell(1:nForms),'jsoup_doc',d);

for iForm = 1:nForms
    form_obj   = form_tags.get(iForm-1);
    output(iForm).form = html_getAttributesTag(form_obj);
    
    %Overwrite with absolute url ...
    output(iForm).form.action = char(form_obj.attr('abs:action'));
    
    %This little bit here is so that I can establish order 
    %of the tags in the document 
    %It was definitely an afterthought and not worked well into the
    %code that follows it ...
    allTags = form_obj.select('input, textarea, button, select');
    
    order    = 1:allTags.size;
    tag_type = zeros(1,allTags.size);
    for iTag = 1:allTags.size;
        cur_tag = allTags.get(iTag-1);
        switch char(cur_tag.tag.toString)
            case 'select'
                tag_type(iTag) = 1;
            case 'textarea'
                tag_type(iTag) = 2;
            case 'input'
                tag_type(iTag) = 3;
            case 'button'
                tag_type(iTag) = 4;    
        end
    end
    
    %SELECT TAGS
    %===============================================================
    %NOTE: Could speed up by getting from list above ...
    select_tags = form_obj.getElementsByTag('select');
    nSelect = select_tags.size;
    if nSelect == 0
        output_selectTags = [];
    else
        clear output_selectTags
        output_selectTags(nSelect) = struct;
        local_order = order(tag_type == 1);
        for iSelect = 1:select_tags.size
            select_obj = select_tags.get(iSelect-1);
            output_selectTags(iSelect).att = html_getAttributesTag(select_obj);
            output_selectTags(iSelect).start_location = local_order(iSelect);
            
            option_tags = select_obj.getElementsByTag('option');
            nOptions = option_tags.size;
            if nOptions == 0
                optionStruct = [];
            else
                %Make this a function???
                clear optionStruct
                optionStruct(nOptions) = struct('data','','value','','selected',''); %#ok<*AGROW>
                for iOption = 1:nOptions
                    option_obj = option_tags.get(iOption-1);
                    optionStruct = html_getAttributesTag(option_obj,optionStruct,iOption);
                    optionStruct(iOption).data = char(option_obj.text);
                end
            end
            output_selectTags(iSelect).options = optionStruct;
        end
    end
    output(iForm).select = output_selectTags;
    
    %TEXT AREA
    %======================================================================
    text_area_tags = form_obj.getElementsByTag('textarea');
    nTextArea      = text_area_tags.size;
    if nTextArea == 0
        output(iForm).taTags = [];
    else
        clear taStruct
        local_order = order(tag_type == 2);
        taStruct(nTextArea) = struct('name','','value','','maxLength','','startLocation',[]);
        for iTA = 1:nTextArea
            text_area_obj = text_area_tags.get(iTA-1);
            taStruct = html_getAttributesTag(text_area_obj,taStruct,iTA);
            taStruct(iTA).start_location = local_order(iTA);
        end
        output(iForm).taTags = taStruct;
    end
    
    %GETTING ALL INPUT TAGS AND ATTRIBUTES ...
    %=================================================================
    
    %JAH TODO: Fix this ...
    
    %input_tags = form_obj.getElementsByTag('input');
    input_tags = form_obj.select('input, button');
    nInputs = input_tags.size;
    if nInputs == 0
        output(iForm).input = [];
        continue
    end
    
    clear inputStruct
    %JAH TODO: CLEAN THIS UP
    local_order = order(tag_type == 3 | tag_type == 4);
    inputStruct(nInputs) = struct('type','','name','','value','','start_location','','checked','','maxlength','');
    for iInput = 1:nInputs
        input_obj = input_tags.get(iInput - 1);
        inputStruct = html_getAttributesTag(input_obj,inputStruct,iInput);
        if isempty(inputStruct(iInput).type)
            inputStruct(iInput).type = 'text';
        end
        inputStruct(iInput).start_location = local_order(iInput);
    end
    
    %Reduction to arrays ...
    input_types  = lower({inputStruct.type});
    input_names  = {inputStruct.name};
    input_values = {inputStruct.value};
    input_starts = {inputStruct.start_location};
    input_checked = {inputStruct.checked};
    maxLength = {inputStruct.maxlength};
    
     %TEXT
        %============================================================
        I_text  = find(ismember(input_types,{'text' 'password'}));
        I_text2 = find(strcmp(input_types,{'hidden'})); %NOTE: I separate
        %these as they shouldn't be changed
                
        if ~isempty(I_text)
            paramValueStruct = struct(...
                'name',     input_names(I_text), ...
                'value',    input_values(I_text), ...
                'id',       num2cell(I_text), ...
                'maxLength',maxLength(I_text),...
                'start_location',input_starts(I_text));
        else
            paramValueStruct = [];
        end
        
        if ~isempty(I_text2)
            paramValueStruct2 = struct(...
                'name',     input_names(I_text2),...
                'value',    input_values(I_text2),...
                'id',       num2cell(I_text2), ...
                'maxLength',maxLength(I_text2),...
                'start_location',input_starts(I_text2));
        else
            paramValueStruct2 = [];
        end
        
        %RADIO
        %=============================================================
        I_radio = find(strcmp(input_types,'radio'));
        if ~isempty(I_radio)
            radio_names  = input_names(I_radio);
            [uNames,~,J] = unique(radio_names);
            radioGroups  = struct('name',uNames,'values','','ids',[],'isChecked','','start_location',[]);  %Careful, note
            %that ids represents those that are part of the group
            for i_group = 1:length(uNames)
                indexMatch = I_radio(J == i_group);
                radioGroups(i_group).values         = input_values(indexMatch);
                radioGroups(i_group).ids            = indexMatch;
                radioGroups(i_group).checked        = input_checked(indexMatch);
                radioGroups(i_group).start_location = input_starts{indexMatch(1)};
            end
        else
            radioGroups = struct([]);
        end
        
        %CHECK_BOX
        %==============================================================
        I_checkBox = find(strcmp(input_types,'checkbox'));
        if ~isempty(I_checkBox)
            checkOptions = struct(...
                'name',     input_names(I_checkBox), ...
                'value',    input_values(I_checkBox), ...
                'id',       num2cell(I_checkBox), ...
                'isChecked',input_checked(I_checkBox),...
                'start_location',input_starts(I_checkBox));
        else
            checkOptions = struct([]);
        end
        
        %SUBMIT BUTTONS
        %==============================================================
        I_button = find(ismember(input_types,{'submit' 'button' 'reset'})); 
        if ~isempty(I_button)
            buttonOptions = struct(...
                'name',     input_names(I_button),...
                'value',    input_values(I_button),...
                'id',       num2cell(I_button),...
                'start_location',input_starts(I_button));
        else
            buttonOptions = struct([]);
        end
        
        output(iForm).input = struct('tags',inputStruct,'pvStruct',paramValueStruct,'pvStruct2',paramValueStruct2,...
            'radioGroups',radioGroups,'checkOptions',checkOptions,'buttonOptions',buttonOptions);
 
end
