classdef button < html.form.element
    %
    %
    %   http://www.w3schools.com/tags/tag_button.asp
    %
    % The <button> tag defines a clickable button.
    %
    % Inside a <button> element you can put content, like text or images. This
    % is the difference between this element and buttons created with the
    % <input> element.
    %
    % Tip: Always specify the type attribute for a <button> element. Different
    % browsers use different default types for the <button> element.
    
    %{
    
    
    
    %}
    
    properties
        %autofocus
        %formtarget
    end
    
    %Submit Properties    =============================================
    properties
        form_action        %url - Where to send the form data
        
        form_encoding_type
        %- application/x-www-form-urlencoded
        %- multipart/form-data
        %- multipart/form-data
        
        form_method
        %- get
        %- post
        
        %form_no_validate
        
        
    end
    
    properties
        %disabled
        %form
        
        
        
        name
        type
        %- button
        %- reset
        %- submit
        value %value to submit
    end
    
    methods
        function obj = button(varargin)
            obj@html.form.element(varargin{:});
            
            
            
        end
    end
    
end

