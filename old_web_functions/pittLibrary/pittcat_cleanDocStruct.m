function docStruct = pittcat_cleanDocStruct(docStruct)
%pittcat_cleanDocStruct
%
%   docStruct = pittcat_cleanDocStruct(docStruct)
%
if isnumeric(docStruct.volume)
    docStruct.volume = int2str(docStruct.volume);
end

if isnumeric(docStruct.issue)
    docStruct.issue = int2str(docStruct.issue);
end

if isnumeric(docStruct.year)
    docStruct.year = int2str(docStruct.year);
end

if isnumeric(docStruct.pmid)
    docStruct.pmid = int2str(docStruct.pmid);
end

end

