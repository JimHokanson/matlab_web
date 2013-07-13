function header = getAuthorizationHeader(obj)
%getAuthorizationHeader  Returns Authorization Header
%
%   header = getAuthorizationHeader(oauth_params)
%
%   Requires signature already be included


params = obj.params;
%Implementation of 3.5.1
if ~isempty(params)
    authHeader = '';
    for i = 1:2:length(params)
        if (i == 1), separator = 'OAuth '; else separator = ', '; end
        param = oauth.percentEncodeString(params{i});
        value = oauth.percentEncodeString(params{i+1});
        authHeader = [authHeader separator param '="' value '"']; %#ok<*AGROW>
    end
end

header = struct;
header.name    = 'Authorization';
header.value   = authHeader;

end