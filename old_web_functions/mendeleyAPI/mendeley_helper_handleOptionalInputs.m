function mendeley_helper_handleOptionalInputs(optionalVariables)
%
%   JAH TODO: Document me
%


temp = evalin('caller','whos');

inputVariables = {temp.name};

missingVariables = setdiff(optionalVariables,inputVariables);
for i_Missing = 1:length(missingVariables)
    assignin('caller',missingVariables{i_Missing},''); 
end
