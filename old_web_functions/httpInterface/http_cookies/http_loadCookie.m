function [header,h,cookie_file_path] = http_loadCookie(url)
%http_loadCookie Loads cookie based on the URL
%
%   CALLING FORMS:
%   ===============================================
%   [header,h,cookie_file_path] = http_loadCookie(url_obj) (PREFFERED)
%
%   ... = http_loadCookie(url)
%
%   INPUTS
%   =======================================================================
%   url_obj : (class java.net.URL)
%   url     : string representing the url
%
%   OUTPUTS
%   =======================================================================
%   header : returns a cookie header for each cookie
%      .name  - 'Cookie'
%      .value - value of the cookie (to send back to the server)
%   h      : handle to cookie structure
%   cookie_file_path: path of where the cookie information is saved
%
%   See Also:
%       http_getCookiesFromFile
%       url_parseURL
%       http_findCookies

[h,cookie_file_path] = http_getCookiesFromFile;

pURL     = url_parseURL(url);
I_Cookie = http_findCookies(h,lower(pURL.domain),pURL.fullPath);

if isempty(I_Cookie)
    header = [];
    return
end

isSecureProtocol = strcmp(pURL.scheme,'https');

isBad = (h.cExpires(I_Cookie) < now & h.cExpires(I_Cookie) ~= 0) ... %expires
        | (h.cSecure(I_Cookie) & ~isSecureProtocol);
%If = 0, then should get rid of cookie when session ends

I_Cookie(isBad) = [];

if isempty(I_Cookie)
   header = [];
   return 
end

h.lastAccess(I_Cookie) = now;

names  = h.cNames(I_Cookie);
[names,I] = sort(names);
values = h.cValues(I_Cookie);
values = values(I);
%Not sure if sorting is necessary ...

pairs  = cellfun(@simpleConcatenateHelper,names,values,'un',0);
value  = cellArrayToString(pairs,'; ');

header = http_createHeader('Cookie',value);



end

function pair = simpleConcatenateHelper(x,y)
    pair = [x '=' y];
end