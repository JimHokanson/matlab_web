function mendeley_open_documentation(filename)
%mendeley_open_documentation Opens browser to documentation page
%
%   mendeley_open_documentation(filename)

help_raw = help(filename);


%EXAMPLE:
%#doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-authored

doc_page = regexp(help_raw,'(?<=#doc_page:\s*)(http\S*)','match','once');
if ~isempty(doc_page)
   openWebBrowser(doc_page); 
end




