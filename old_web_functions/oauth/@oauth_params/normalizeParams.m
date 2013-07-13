function normParams = normalizeParams(params)
%oauth_normalizeParams  Normalizes parameters for signature
%
%   Takes an input string and percent encodes it based on Section 3.4.1.3.2
%   of the Oauth Protocol
%
%   normParams = oauth_normalizeParams(params)
%
%   INPUT
%   ===========================================================
%   params : cell array of strings, NOT PERCENT ENCODED, in name,value form
%
%   OUTPUT
%   ===========================================================
%   normParams: a single string for use with base string
%
%   NOTE: the parameters 'oauth_signature' &'realm' are removed if present
%
%   See Also: 
%   sortCellArrayRows
%   cellArrayToString
%
%   http://tools.ietf.org/html/rfc5849#section-3.4.1.3.2


BAD_PARAMETERS = {'oauth_signature','realm'};
CAT_STRING_1 = '=';
CAT_STRING_2 = '&';

%1) PERCENT ENCODING
params = cellfun(@oauth.percentEncodeString,params,'un',0);

%2) SORTING BY NAME THEN VALUE
params = reshape(params(:),2,length(params)/2)';
%make params in this form:
%Column 1: names
%Column 2: values
    
%NOTE: This function first sorts by the 1st column (names)
%and then sorts by the 2nd column (values)
%This takes into account situations of duplicate names
%but different values (this is possible for FORM 1)
params = sortCellArrayRows(params);

names  = params(:,1);
values = params(:,2);

removeMask = ismember(names,BAD_PARAMETERS);
names(removeMask)  = [];
values(removeMask) = [];

%3) CONCATENATION OF NAME & VALUE
nameValPair = cellfun(@(x,y) [x CAT_STRING_1 y],names,values,'un',0);

%4) PAIR CONCATENATION
normParams = cellArrayToString(nameValPair,CAT_STRING_2,true);
