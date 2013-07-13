function str2 = depercentEncode(str)
%depercentEncode Undoes the percent encode process
%
%   str2 = depercentEncode(str)

keep_mask = true(1,length(str));
I_PER = strfind(str,'%');
for iFix = I_PER(end:-1:1)
    str(iFix) = char(hex2dec(str(iFix+1:iFix+2)));
    keep_mask(iFix+1:iFix+2) = false;
end

str2 = str(keep_mask);