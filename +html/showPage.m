function showPage(web_page_str)
%showPage Opens web page text in a brower window for rendering
%
%   html.showPage(web_page_string)
%
%   JAH TODO: Document function
%

if nargin == 0
    error('Text input must be given')
end

if isjava(web_page_str)
    %Java string ...
    web_page_str = char(web_page_str);
end

filePath = fullfile(tempdir,'html_debug.htm');
fid      = fopen(filePath,'w+');
fwrite(fid,web_page_str,'char');
fclose(fid);

html.openWebBrowser(filePath)
end