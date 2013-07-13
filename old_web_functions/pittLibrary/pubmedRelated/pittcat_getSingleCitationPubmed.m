function [docStructNew,pmstruct,status] = pittcat_getSingleCitationPubmed(docStruct,varargin)
%pittcat_getSingleCitationPubmed
%
%   [docStructNew,pmstruct,status] = pittcat_getSingleCitationPubmed(docStruct,varargin)
%
%   INPUT FIELDS USED
%   ===========================
%   .journal
%   .volume
%   .issue
%   .year
%   .title
%
%
%   OUTPUTS
%   =======================================================================
%   status
%   0 - no match
%   1 - 1 match
%   2 - many matches
%
%SOME OF THIS FUNCTIONALITY SHOULD BE MOVED TO A PUBMED FUNCTION

%EXAMPLE REQUEST
%-------------------------------------------------------------------------
%pubmed_search('"J Neurosurg"[Journal] AND 42[volume] AND 1975[pdat] AND (Relief[Title] AND pain[Title] AND transcutaneous[Title] AND stimulation[Title])')

DEFINE_CONSTANTS
SHOW_WARNING = false;
WORD_MIN = 4;
END_DEFINE_CONSTANTS


AND_T = ' AND ';
searchQuery = [];

if isfield(docStruct,'journal') && ~isempty(docStruct.journal)
    searchQuery = ['"' searchQuery docStruct.journal '"' '[Journal]' AND_T];
end
if isfield(docStruct,'volume') && ~isempty(docStruct.volume)
    searchQuery = [searchQuery docStruct.volume '[Volume]' AND_T];
end
if isfield(docStruct,'issue') && ~isempty(docStruct.issue)
    searchQuery = [searchQuery docStruct.issue '[Issue]' AND_T];
end
if isfield(docStruct,'year') && ~isempty(docStruct.year)
    searchQuery = [searchQuery docStruct.year '[pdat]' AND_T];
end

if isfield(docStruct,'title') && ~isempty(docStruct.title)
    words = getWords(docStruct.title);
    words(cellfun('length',words) < WORD_MIN) = [];
    words = cellfun(@(x) [x '[Title]'],words,'UniformOutput',false);
    searchQuery = [searchQuery '(' cellArrayToString(words,AND_T,true) ')'];
else
    searchQuery(end-4:end) = []; %Remove the AND_T
end

[pmstruct,medlineText] = pubmed_search(searchQuery);
%ON FAILURE, COULD TRY REMOVING THINGS

docStructNew = docStruct;
if length(pmstruct) == 1 && all(cellfun(@(x) isempty(pmstruct.(x)),fieldnames(pmstruct)))
    %MORE PROCESSING?
    status = 0;
elseif length(pmstruct) == 1
    docStructNew = pittcat_pubmedStructToPittcat(pmstruct);
    status = 1;
else
    %MORE PROCESSING?
    status = 2;
end

if SHOW_WARNING && status ~= 1
    if status == 0
        formattedWarning('Failed to get any Pubmed matches')
    else
        formattedWarning(sprintf('Returned multiple Pubmed matches: %d',length(pmstruct)))
    end
end
  