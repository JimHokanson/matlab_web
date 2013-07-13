classdef input < html.form.element
    %
    %
    %   Class:
    %   html.form.input
    %
    % button
    % checkbox
    % color
    % date
    % datetime
    % datetime-local
    % email
    % file
    % hidden
    % image
    % month
    % number
    % password
    % radio
    % range
    % reset
    % search
    % submit
    % tel
    % text
    % time
    % url
    % week
    
    %Specific to Type
    %-------------------------------
    %accept - file
    %alt    - image
    %
    %Submission types
    %-------------------------------
    %
    
    
    
    %Not Supported
    %-------------------------------
    %- autocomplete
    %- autofocus
    %
    %
    %- disabled
    %- form   %form_id
    %- 
    
    properties
        type
    end
    
    methods
        function obj = input(varargin)
            obj@html.form.element(varargin{:});
        end
    end
    
    methods (Static)
        function obj = populate(element_tag,index)
            %
            %   objs = html.form.input.populate(element_tags,indices)
            %
            %   INPUTS
            %   =========================================================
            %   element_tags : cell array
            %   indices      : order ...
            
            
            cur_type = char(element_tag.attr('type'));
            
            % http://www.w3schools.com/tags/att_input_type.asp
            
            switch cur_type
                case ''
                    cur_type = 'text'; %Default type is text
                    fh = @html.form.input.text;
                case 'button'
                    fh = @html.form.input.button;
                case 'checkbox'
                    fh = @html.form.input.checkbox;
                    %case 'color'
                    %case 'date'
                    %case 'datetime'
                    %case 'datetime-local'
                    %case 'email'
                case 'file'
                    fh = @html.form.input.file;
                case 'hidden'
                    fh = @html.form.input.hidden;
                case 'image'
                    fh = @html.form.input.image;
                    %case 'month'
                    %case 'number'
                case 'password'
                    fh = @html.form.input.password;
                case 'radio'
                    fh = @html.form.input.radio;
                    %case 'range'
                case 'reset'
                    fh = @html.form.input.reset;
                case 'search'
                    fh = @html.form.input.search;
                case 'submit'
                    fh = @html.form.input.reset;
                    %case 'tel'
                case 'text'
                    fh = @html.form.input.text;
                    %case 'time'
                    %case 'url'
                    %case 'week'
                otherwise
                    cur_type = 'unhandled';
                    %NOTE: The raw tag can be used to find the true
                    %underyling tag
                    
                    fh = @html.form.input.unhandled;
                    %Create unhandled input type
                    %Move to being separate, perhaps show warning ...
            end
            
            %Show warning ????
            
            obj = fh(element_tag,index);
            
            obj.type = cur_type;
            
        end
        %METHODS
        %- choose button
    end
    
end

