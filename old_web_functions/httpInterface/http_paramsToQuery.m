function [queryString,header] = http_paramsToQuery(params,encodeOption)
%http_paramsToQuery Creates the query string for a post or get
%
%   [queryString,header] = http_paramsToQuery(params,encodeOption)
%   
%   In general GET method calls should call http_makeGetUrl instead
%
%   INPUTS
%   =======================================================================
%   params: cell array of property/value pairs
%           NOTE: iF the input is in a 2 column matrix, then first column
%           entries are properties and the second column entries are
%           values, however this is NOT necessary (generally linear)
%   encodeOption: (default 1)
%           1 - the typical URL encoding scheme (Java call)
%           2 - oauth encoding scheme (calls oauth library) 
%               #2 REQUIRES the web toolbox
%               
%   OUTPUTS
%   =======================================================================
%   queryString: querystring to add onto URL (LACKS "?", see example)
%   header     : the header that should be attached for post requests when
%                using urlread2
%
%   EXAMPLE:
%   ==============================================================
%   params = {'cmd' 'search' 'db' 'pubmed' 'term' 'wtf batman'};
%   queryString = http_paramsToQuery(params);
%   queryString => cmd=search&db=pubmed&term=wtf+batman
%
%   IMPORTANT: This function does not filter parameters, sort them,
%   or remove empty inputs (if necessary), this must be done before hand
%
%   See Also:
%       form_submit
%       http_makeGetUrl
%       oauth_percentEncodeString
%       http_getContentTypeHeader

deprecatedWarning('','http_paramsToString','Better name and reduced code footprint') 

disp(createLinkForCommands('Open to debug line','goDebug'))
keyboard

if ~exist('encodeOption','var')
    encodeOption = 1;
end

if size(params,2) == 2 && size(params,1) > 1
    params = params';
    params = params(:);
end

queryString = '';
for i=1:2:length(params)
    if (i == 1), separator = ''; else separator = '&'; end
    switch encodeOption
        case 1
            param = urlencode(params{i});
            value = urlencode(params{i+1});
        case 2
            param    = oauth.percentEncodeString(params{i});
            value    = oauth.percentEncodeString(params{i+1});
        otherwise
            error('Case not used')
    end
    queryString = [queryString separator param '=' value]; %#ok<AGROW>
end

header = http_getContentTypeHeader(1);


end