function output = http_parseCookie(headers,url)
%http_parseCookie  Parses a cookie header
%
%   output = http_parseCookie(headers,url)
%
%   Called by: http_saveCookie
%
%   INPUTS
%   =======================================================================
%   headers : (structure), from urlread2
%       .Set_Cookie - cookie text as sent to client, not parsed
%   url     : request url, needed for path and domain handling
%
%   OUTPUT
%   =======================================================================
%   output : (structure)
%       .type  - 'Set-Cookie'
%       .raw   - unprocessed cookie
%       .value - value of the cookie
%       .name  - name of the cookie
%       .secure - logical
%       .httpOnly - logical
%       .domain   - domain that this cookie applies to
%       .expires  - logical
%       .path     - path that this cookie applies to
%
%   EXAMPLE
%   =======================================================================
%   headers.Set_Cookie = {['LSID=DQAAAK…Eaem_vYg; Domain=docs.foo.com; ' ...
%   'Path=/accounts; Expires=Wed, 13-Jan-2021 22:23:01 GMT; Secure; HttpOnly']};
%   url = 'http://www.docs.foo.com/accounts/temp';
%   output = http_parseCookie(headers,url)
%         type: 'Set-Cookie'
%          raw: [1x113 char]
%        value: 'DQAAAK…Eaem_vYg'
%         name: 'LSID'
%       secure: 1
%     httpOnly: 1
%       domain: '.docs.foo.com'
%      expires: 7.3817e+005
%         path: '/accounts'
%
%   See Also:
%       http_saveCookie

%http://tools.ietf.org/html/rfc6265

%NOTE: http_saveCookie checks for this field existing
cookie_headers = headers.Set_Cookie;
parsedURL      = url_parseURL(url);

output = struct(...
    'type',     'Set-Cookie',...
    'raw',      cookie_headers,...
    'value',    '', ...
    'name',     '',...
    'secure',   false,...
    'httpOnly', false,...
    'domain',   '',...
    'expires',  0,...
    'path',     '/');

for iEntry = 1:length(cookie_headers)
    values = regexp(cookie_headers{iEntry},';[\s]*','split');
    
    %Remove the extra entry if cookie ends with a semicolon
    if isempty(values{end})
        values(end) = '';
    end
    
    curText = values{1};
    I_equals = find(curText == '=',1);
    output(iEntry).name  = curText(1:I_equals-1);
    output(iEntry).value = curText(I_equals+1:end);
    
    for iTemp = 2:length(values)
        curText = values{iTemp};
        
        I_equals = find(curText == '=',1);
        
        if isempty(I_equals)
            name  = curText;
            value = '';
        else
            name  = curText(1:I_equals(1)-1);
            value = curText(I_equals(1)+1:end);
        end
        
        switch lower(name)
            case 'domain'
                output(iEntry).domain = lower(value);
            case 'expires'
                %NOTE: might get overwritten by maxAge
                %EXAMPLE
                %Sun, 17-Jan-2038 19:14:07 GMT
                %NOTE: This might not be the format, will implement
                %something more complicated when this breaks
                output(iEntry).expires = datenum(value,'ddd, dd-mmm-yyyy HH:MM:SS ') + getTimeZoneShift/24;
            case 3 %Path
                if isempty(value)
                    value = '/';
                end
                output(iEntry).path = value;
            case 'secure'
                output(iEntry).secure = true;
            case 'httponly'
                output(iEntry).httpOnly = true;
            case 'max-age'
                %Value should be seconds from now
                output(iEntry).expires = now + str2double(value)/(24*60*60);
        end
    end
    
    if isempty(output(iEntry).domain)
        %NOTE: this will not have a leading "." character
        %This is fine since it came from the same domain
        output(iEntry).domain = parsedURL.domain;
    end
    
% % %     if isempty(output(iEntry).path)
% % %         output(iEntry).path = '' parsedURL.fullPath;
% % %     end
    
end