classdef label < html.form.element
    %label
    %
    %   http://www.w3schools.com/tags/tag_label.asp
    %
    %   The for attribute of the <label> tag should be equal to the id
    %   attribute of the related element to bind them together.
    %
    
    %{
        <form action="demo_form.asp">
          <label for="male">Male</label>
          <input type="radio" name="sex" id="male" value="male"><br>
          <label for="female">Female</label>
          <input type="radio" name="sex" id="female" value="female"><br>
          <input type="submit" value="Submit">
        </form>
    %}
    
    %Methods yet to implement: (LOW PRIORITY)
    %-------------------------------------------------------------
    %1) Assign value to id
    
    properties
        for_id
        form
    end
    
    methods
        function obj = label(varargin)
            obj@html.form.element(varargin{:})
        end
        function prop_value_pair = getResponse(~)
            prop_value_pair = {};
        end
    end
    
end

