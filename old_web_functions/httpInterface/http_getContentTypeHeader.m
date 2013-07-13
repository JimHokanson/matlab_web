function header = http_getContentTypeHeader(option)
%http_getContentTypeHeader  Creates 'Content-Type' header
%
%   header = http_getContentTypeHeader(option)
%
%   INPUTS
%   ===========================================================
%   option: (encoding option)
%       1 - 'application/x-www-form-urlencoded'
%
%   See Also:
%       urlread2
%       http_paramsToQuery

deprecatedWarning('','http_paramsToString',...
    'This function should no longer be used, calling function should incorporate functionality')

header = struct;
header.name = 'Content-Type';

switch option
    case 1
        header.value = 'application/x-www-form-urlencoded';
end

