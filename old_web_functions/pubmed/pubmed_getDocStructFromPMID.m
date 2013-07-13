function docStruct = pubmed_getDocStructFromPMID(pmid)
%pubmed_getDocStructFromPMID
%
%   docStruct = pubmed_getDocStructFromPMID(pmid)
%
%   INPUTS
%   -----------------------------------------------------------
%   pmid - may be numeric or string
%
%   Has the potential to abstract the call to pubmed_search
%
%   See Also: pubmed_search
%
%   JAH TODO: Finish documentation

if isnumeric(pmid)
    pmid = sprintf('%ld',pmid);
end

%NOTE: We could modify this to get more info out, the original
%format is easier to process
docStruct = pubmed_search([pmid '[uid]']);


