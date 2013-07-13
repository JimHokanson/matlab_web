function pittcat_openRequestFile
%pittcat_openRequestFile  Quick method for updating log of received documents
%   
%   pittcat_openRequestFile
%
%   Windows:
%   - opens file in notepad for simple editing (adding received date)
%

temp = pittcat_getUserInfo;
    
if ispc
    system(sprintf('notepad %s',temp.requestPath))
else
    error('Not yet implemented')
end