function output = requestStringToParamValueStruct(inputString)
%requestStringToParamValueStruct  Takes a response and puts into a structure
%
%   output = requestStringToParamValueStruct(inputString)
%
%   inputString => oauth_callback_accepted=1&oauth_token=f91b927c9575dcc1039195ca9e19d2fc04d782ebd
%
%   output =>
%       .oauth_callback_accepted: '1'
%       .oauth_token: '8a87a8f8db427163e531f17dcf52e3d304d78300b'
%
%   QUESTION: Are these responses urlEncoded???
%
%   See Also: stringToCellArray

temp  = stringToCellArray(inputString,'&');
temp2 = cellfun(@(x) stringToCellArray(x,'='),temp,'UniformOutput',false);

fNames = cellfun(@(x) x{1},temp2,'UniformOutput',false);
fValues = cellfun(@(x) x{2},temp2,'UniformOutput',false);

output = struct([]);
for iName = 1:length(fNames)
    output(1).(fNames{iName}) = fValues{(iName)};
end

formStruct = form_helper_setTextValue(formStruct,'jour',docStruct.journal);
formStruct = form_helper_setTextValue(formStruct,'year',docStruct.year);
formStruct = form_helper_setTextValue(formStruct,'volume',docStruct.volume);
formStruct = form_helper_setTextValue(formStruct,'issue',docStruct.issue);
%formStruct = form_helper_setTextValue(formStruct,'page',searchText); %first page
formStruct = form_helper_setTextValue(formStruct,'title',docStruct.title); %first page
