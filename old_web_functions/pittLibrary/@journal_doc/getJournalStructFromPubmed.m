function getJournalStructFromPubmed(obj,id)
%getJournalStructFromPubmed  Returns document structure given Pubmed ID
%
%	docStruct = getJournalStructFromPubmed(id)
%
%   INPUTS
%   ====================================================
%   id - numeric or string, Pubmed ID

if ~exist('id','var') || isempty(id)
    error('Pubmed ID needs to be specified')
end


%JAH TODO: Merge functions

pm = pubmed_getDocStructFromPMID(id);
populateObjFromPubmedStruct(obj,pm);

