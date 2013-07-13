function pmid = mendeley_local_getPMIDfromClipboard
%mendeley_local_getPMIDfromClipboard
%
%   pmid = mendeley_local_getPMIDfromClipboard
%
%   Might return:
%   - pubmed id as a string
%   - 'no match'
%   - 'multiple matches'
%
%   JAH TODO: Document function, what the heck does this do?

pat = '\[\d+\](?<authors>[^“]+)“(?<title>.*?)\.?,”\s*(?<journal>[^,\(\)]+).*?(?<year>((19)|(20))\d+)';

temp = regexp(clipboard('paste'),pat,'names');

temp = rmfield(temp,'authors');


[docStructNew,pmstruct,status] = pittcat_getSingleCitationPubmed(temp);

if status == 1
    pmid = pmstruct.PMID;
elseif status == 0
    pmid = 'no match';
else
    pmid = 'multiple matches';
end
    