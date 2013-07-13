function http_saveCookie(headers,url,h,cookie_file_path)
%saveCookie Saves cookies to disk
%
%   http_saveCookie(headers,url)
%
%   This function matches a cookie to already existing cookies, updating if
%   necessary, and then saves the results to disk. In addition if space is
%   lacking then the cookie storage is trimmed for more space.
%
%   Called By: urlread2
%
%   INPUTS
%   =======================================================================
%   headers : (structure), should contain field Set_Cookie
%   url     : url whose request generated the headers from the server
%
%   JAH IMPROVEMENTS
%   =======================================================================
%   1) Check that the domain is ok, i.e. that the url has permission to 
%      set the cookie
%      SEE NOTES IN CODE
%
%   See Also:
%       urlread2
%       http_getCookiesFromFile
%       http_findCookies

if ~isfield(headers,'Set_Cookie')
    return
end

cookies = http_parseCookie(headers,url);

for i_cookie = 1:length(cookies)
    curCookie = cookies(i_cookie);
    
    %JAH TO IMPLEMENT
    %==========================================================================
    %http://en.wikipedia.org/wiki/HTTP_cookie#Third-party_cookie
    %http://en.wikipedia.org/wiki/HTTP_cookie#Privacy_and_third-party_cookies
    %1) subdomain - i.e. that the specified domain is a subdomain of
    %   the url requesting the save, i.e. google.com shouldn't be able
    %   to set a cookie with a domain of facebook.com - Third-Party
    %   Cookies
    %
    %http://en.wikipedia.org/wiki/HTTP_cookie#Supercookie
    %2) Not on public domain list - not sure how to do this ...
    %   i.e scholar.google.com can set for google.com, but it can't set
    %   for .com, as that is not owned by Google, yet ...
    
    I_Cookie = http_findCookies(h,curCookie.domain,curCookie.path,curCookie.name);
    
    if isempty(I_Cookie) %Then we need to add it on
        if h.curIndex == length(h.cNames)
            h = http_trimCookies(h);
        end
        curIndex   = h.curIndex + 1;
        h.curIndex = curIndex;
        
        
        
        %assign the important things
        h.created(curIndex)     = now;
        h.cDomain{curIndex}     = lower(curCookie.domain(end:-1:1));
        h.cPath{curIndex}       = curCookie.path;
        h.cNames{curIndex}      = curCookie.name;
    else
        if length(I_Cookie) ~= 1
            error('Unexpected result, multiple cookies matched')
        end
        curIndex = I_Cookie;
    end
    
    h.cValues{curIndex}     = curCookie.value;
    h.cSecure(curIndex)     = curCookie.secure;
    h.cHOnly(curIndex)      = curCookie.httpOnly;
    h.cExpires(curIndex)    = curCookie.expires;
    
end

%NOTE: Ths is an assumption that the files are NOT unicode
%I believe the specification is that the headers should be ascii ...
save(cookie_file_path,'h','-v6');


end






