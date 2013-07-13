function compareAndSave(obj,fcn_name,output,otherStruct)

%
%   NOTE: need to incorporate flags, only check if successful on both
%

% % if exist(obj.test_directory,'dir')
% %     mat_file_path = fullfile(obj.test_directory,[fcn_name '.mat']);
% %     if exist(mat_file_path,'file')
% %         h = load(mat_file_path);
% %         if ~isequal(fieldnames(h.outputCA{end}),output)
% %             fprintf(2,'Fieldnames don''t match for %s\n',fcn_name);
% %         end
% %         outputCA = [outputCA {output}]; %#ok<*NODEF>
% %         otherCA  = [otherCA {otherStruct}];
% %         request  = [request now]; %#ok<*NASGU>
% %     else
% %         %SAVE FORMAT
% %         %-------------------------------
% %         %output{},request()
% %         outputCA = {output};
% %         otherCA  = {otherStruct};
% %         request  = now;
% %         
% %     end
% %     VERSION = obj.MAT_VERSION;
% %     save(mat_file_path,'outputCA','otherCA','request','VERSION');
% % end

end