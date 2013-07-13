function openWebBrowser(address)
% openWebBrowser Opens web browser to the supplied address
%
%   openWebBrowser(address)
%  
% The selected web browser depends on ths operating system.
% Firefox call requires firefox to be defined in the user's system path.
%
% INPUTS
% ========================================================================
% address: generally a http url, allow others may be supported (like file)
%
% SYSTEM CONSIDERATIONS
% =======================================================
% MAC  : default application to open HTML files
% PC   : default browser
% UNIX : firefox
%
%   tags: web
%   see also: web

if nargin == 0
    address = '';
end

%NOTE: We could allow this to rely on the user constants
if isempty(address)
    address='http://www.google.com/'; 
end

if ispc
    %start    -> works for web addresses www.cnn.com
    %explorer -> works for files with spaces 
    %complete addresses http://www.cnn.com
    
    %OLD CODE
%     browser = 'firefox.exe';
%     status  = system(sprintf('%s %s &',browser, address));
    
    %In case we wanted to do something OS dependent
    %system_dependent('getos')
    
    if strncmp(address,'"file://',7) || strncmp(address,'file://',7) || exist(address,'file')
        system(['explorer ' address]);
    else
        system(['start ' address]);
    end
elseif ismac
    browser = 'open'; % Dynamically uses default application
    
    system(sprintf('%s %s &',browser, address));
elseif isunix
    browser = 'firefox';
    system(sprintf('%s %s &',browser, address));
end


end
