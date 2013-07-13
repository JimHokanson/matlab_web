function disp(obj)
%disp Overrides display to show parameters more explicitly, as well as options

op = obj.parent;

fprintf('\nPARAMETERS:\n')
dispPropValuePairs(obj.params)

TF = {'true' 'false'};

fprintf('\nPROCESSING_OPTIONS:\n')
pv = {'opt_allow_empty_oauth_params' TF{op.opt_allow_empty_oauth_params+1}...
    'opt_cast_numbers_to_strings' TF{op.opt_cast_numbers_to_strings+1} ...
    'opt_number_to_string_fhandle' func2str(op.opt_number_to_string_fhandle) ...
    'opt_convert_params_to_utf8' TF{op.opt_convert_params_to_utf8}};
dispPropValuePairs(pv)

fprintf('\n<a href="matlab:methods(%s)">%s</a>\n',class(obj),'Detailed Methods');

end

function dispPropValuePairs(pv)
lenProps = cellfun('length',pv(1:2:end));
maxLen   = max(lenProps);
curIndex = 0;
for iParam = 1:2:length(pv)
   curIndex = curIndex + 1;
   nSpaces = maxLen - lenProps(curIndex);
   fprintf('%s%s : %s\n',blanks(nSpaces),pv{iParam},pv{iParam+1});
end


end
