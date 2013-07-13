classdef fieldset < html.form.element
    %
    %
    %
    
    % <form>
    %  <fieldset>
    %   <legend>Personalia:</legend>
    %   Name: <input type="text"><br>
    %   Email: <input type="text"><br>
    %   Date of birth: <input type="text">
    %  </fieldset>
    % </form>
    
    
    
    properties
    end
    
    methods
        function obj = fieldset(varargin)
           obj@html.form.element(varargin{:}) 
        end 
    end
    
end

