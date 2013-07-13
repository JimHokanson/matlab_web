function parse(obj,form_obj)
%
%
%   parse(obj,form_obj)
%
%   INPUTS
%   =======================================================================
%   form_obj : Class: org.jsoup.nodes.Element

ALL_INFO = {
    'input'     'input_tags'        @html.form.input.populate
    'textarea'  'textarea_tags'     @html.form.textarea
    'button'    'button_tags'       @html.form.button
    'select'    'select'       @html.form.select
    %     'option'    'option_tags'       @html.form.option
    %     'optgroup'  'optgroup_tags'     @html.form.optgroup
    %     'fieldset'  'fieldset_tags'     @html.form.fieldset
    'label'     'label'        @html.form.label};

ELEMENT_TYPES = ALL_INFO(:,1)';
PROP_NAMES    = ALL_INFO(:,2)';
F_HANDLES     = ALL_INFO(:,3)';

select_request = sl.cellstr.join(ELEMENT_TYPES,', ');

%Extraction of all relevant elements
%--------------------------------------------------------------------------
form_tags = form_obj.select(select_request);
%Class: org.jsoup.select.Elements


%TODO: Document this more ...

n_element_instances = form_tags.size;

tag_names    = cell(1,n_element_instances);
tag_elements = cell(1,n_element_instances);

for iElement = 1:n_element_instances
    cur_tag   = form_tags.get(iElement-1);
    tag_names{iElement}    = char(cur_tag.tagName);
    tag_elements{iElement} = cur_tag;
end

obj_cell_array = cell(1,n_element_instances);
cur_obj_count  = 0;

for iElementType = 1:length(ELEMENT_TYPES)
    
    indices             = find(strcmp(tag_names,ELEMENT_TYPES{iElementType}));
    cur_function_handle = F_HANDLES{iElementType};
    
    clear temp
    for iIndex = 1:length(indices)
        cur_obj_count = cur_obj_count + 1;
        
        cur_index = indices(iIndex);
        temp(iIndex) = cur_function_handle(tag_elements{cur_index},cur_index);
        obj_cell_array{cur_obj_count} = temp(iIndex);
    end
    
    if ~isempty(indices)
        obj.(PROP_NAMES{iElementType}) = temp;
    end
end

%NOTE: This could be an array since the objects are mixable ...
obj.all_elements = obj_cell_array;

%Higher level processing
%--------------------------------------------------------------------------

%text_objects

%select, get options

end
