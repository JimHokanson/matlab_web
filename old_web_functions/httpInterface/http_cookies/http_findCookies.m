function I_Cookie = http_findCookies(h,cookie_domain,cookie_path,cookie_name)
%http_findCookies Gets cookies that match domain and path, maybe value
%
%   CALLING FORMS
%   ==========================================================
%   I_Cookie = http_findCookies(h,cookie_domain,cookie_path)
%       This is typically called on load to get all valid cookies given the
%   cookie domain and cookie path.
%
%   I_Cookie = http_findCookies(h,cookie_domain,cookie_path,cookie_name)
%       This is typically called on save to overwrite an existing cookie
%   that has the same credentials.
%
%   In general this function should only be called by: 
%       http_saveCookie
%       http_loadCookie
%
%   OUTPUT
%   =======================================================================
%   I_Cookie : matching indices
%
%   INPUTS
%   =======================================================================
%   h      : cookie structure
%   domain : domain to match
%   path   : path to match
%
%   OPTIONAL INPUTS
%   =======================================================================
%   cookie_name : The name of the cookie to match. 
%                IMPORTANT: This forces an exact match of the domain and path.
%
%   See Also:
%       http_saveCookie
%       http_loadCookie
%       http_getCookiesFromFile

%http://tools.ietf.org/html/rfc6265

EXACT_MATCH_ONLY = exist('cookie_name','var');
%NOTE: I use the term exact match because technically if the path and
%domain don't match then values can be repeated
%i.e. scholar.google.com can have a cookie ID=value;
%&    google.com can also have a cookie ID=value;
%This is fine

%NOTE: curIndex indicates how many cookies have been set
curIndex = h.curIndex;

cookie_domain = cookie_domain(end:-1:1);
if EXACT_MATCH_ONLY
    %NOTE: This might not properly handle a leading .
    domainMatch = strcmp(h.cDomain(1:curIndex),cookie_domain);
else
    domainMatch = false(1,curIndex);
    for iDomain = 1:curIndex
        curDomain = h.cDomain{iDomain};
        if curDomain(end) == '.'
            domainMatch(iDomain) = strncmp(curDomain,cookie_domain,length(curDomain)-1);
        else
            domainMatch(iDomain) = strcmp(curDomain,cookie_domain);
        end
    end
end

%PATH MATCHING
%-------------------------------------------
%   CASE 1
%    o  The cookie-path and the request-path are identical.
%
%   CASE 2
%    o  The cookie-path is a prefix of the request-path and the last
%       character of the cookie-path is U+002F ("/").
%
%   CASE 3
%    o  The cookie-path is a prefix of the request-path and the first
%       character of the request-path that is not included in the cookie-
%       path is a U+002F ("/") character.
%
%   Need to clarify what these mean ...
%   request_path - input
%   cookie-path  - from storage
%
%   Example:
%   cookie_path in storage "/"
%   request_path           "/ServiceLogin"
%
%   This would be ok by CASE 2
%           
%


%CASE 1
pathMatch = false(1,curIndex);
pathMatch(domainMatch) = strcmp(h.cPath(domainMatch),cookie_path);
if ~EXACT_MATCH_ONLY
    for iPath = find(domainMatch & ~pathMatch) %To save time only consider matching domains 
          len_cur_cookie = length(h.cPath{iPath});     
          if len_cur_cookie < length(cookie_path) && ...
                  (h.cPath{curIndex}(end) == '/' || cookie_path(len_cur_cookie+1) == '/')
                    %       CASE 2                                 CASE 3
              %Good if prefix
              pathMatch(iPath) = strncmp(h.cPath{iPath},cookie_path,len_cur_cookie);
          end
    end
end

%NOTE: Code above does allow pathMatch if domainMatch is false
if EXACT_MATCH_ONLY
    valueMatch = strcmp(h.cNames(1:curIndex),cookie_name);
    I_Cookie   = find(pathMatch & valueMatch);
else
    I_Cookie   = find(pathMatch);
end
