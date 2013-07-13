function populateObjFromPubmedStruct(obj,pmStruct)
%populateObjFromPubmedStruct  Populates object from pubmed struct
%
%   populateObjFromPubmedStruct(obj,pmStruct)
%
%   class: journal_doc

obj.title   = pmStruct.title;
obj.volume  = pmStruct.volume;
obj.year    = pmStruct.year;
obj.pages   = pmStruct.pages;
obj.authors = pmStruct.authors;
obj.journal = pmStruct.journal;
obj.doi     = pmStruct.doi;
obj.pmid    = pmStruct.PMID;

if ~isempty(pmStruct.issn_print)
    obj.issn    = pmStruct.issn_print{1};
end
