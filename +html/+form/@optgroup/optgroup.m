classdef optgroup < html.form.element
    %
    %
    %
    
    % <select>
    %   <optgroup label="Swedish Cars">
    %     <option value="volvo">Volvo</option>
    %     <option value="saab">Saab</option>
    %   </optgroup>
    %   <optgroup label="German Cars">
    %     <option value="mercedes">Mercedes</option>
    %     <option value="audi">Audi</option>
    %   </optgroup>
    % </select>
    
    
    
    properties
    end
    
    methods
        function obj = optgroup(varargin)
           obj@html.form.element(varargin{:}) 
        end 
    end
    
end

