function [output,otherStruct] = mendeley_pvt_doc_uploadFile(authStruct,id,data,isFilePath,varargin)
%mendeley_pvt_doc_uploadFile
%
%   output = mendeley_pvt_doc_uploadFile(authStruct,id,data,isFilePath)
%   
%   OUTPUTS
%   =======================================================================
%   output = 
%      total_results: 1
%        total_pages: 1
%       current_page: 0
%     items_per_page: 20
%       document_ids: {'2937576181'}
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%   id           : id to upload file to
%
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/file-upload
%
%   See Also: 

%    openExplorerToMfileDirectory('mendeley_pvt_doc_uploadFile')
%    mendeley_open_documentation('mendeley_pvt_doc_uploadFile')

baseUrl = 'http://www.mendeley.com/oapi/library/documents';
url = sprintf('%s/%s/',baseUrl,id);
httpMethod = 'PUT';

if isFilePath
    filePath = data;
    fid = fopen(filePath,'r');
    if fid == -1
        if exist(filePath,'file')
            error('Unable to open existing file for reading')
        else
            error('Specified file doesn''t exist at path: %s',filePath)
        end
    end
    data = fread(fid,[1 Inf],'*uint8');
    fclose(fid);
elseif ischar(data)
    data = unicode2native(data,'UTF-8');
end

hash = oauth.get_SHA1(data);

body = data;

extra_auth_params = {'oauth_body_hash' hash};

myParamsPE = {};

header = struct(...
    'name',{'Content-Type' 'Content-Disposition'},...
    'value',{'application/pdf' 'attachment; filename="testA.pdf"'});

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE,...
    false,'extra_auth_params',extra_auth_params,'body_to_use',body,'extra_headers',header);
