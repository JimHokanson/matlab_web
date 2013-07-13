function header = http_setUserAgent(option)
%httph_setUserAgent
%
%   allHeaders = httph_setUserAgent(option,*allHeaders)
%
%   option
%   -----------------------------------------------------------------------
%   1 : Mozilla/5.0
%   2 : Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.63 Safari/535.7


if ischar(option)
   switch lower(option)
       otherwise
           error('String inputs not yet implemented')
   end
end

switch option
    case 1
        value = 'Mozilla/5.0';
    case 2
        value = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.63 Safari/535.7';
    otherwise
        error('Option: %d not available',option)
end



header = http_createHeader('User-Agent',value);