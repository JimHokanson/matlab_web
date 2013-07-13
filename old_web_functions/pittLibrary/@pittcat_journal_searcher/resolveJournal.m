function results = resolveJournal(obj)
%resolveJournal  Attempts to resolve journal name using Pitt search service
%
%   results = resolveJournal(obj)
%
%   Uses "SerialSolutions" server to search for a journal
%
%   NOTE: The server offers a few different search options, only the first
%   option is used. Options are:
%       - title begins with             ** ONE CURRENTLY USED
%       - title equals
%       - title contains all words
%       - issn equals
%
%   OUTPUTS
%   ======================================
%   results : (structure array) 
%       .title - name of journal
%       .issn  - issn string value
%
%   See Also:
%   pittcat_checkStorage
%
%   NOTES ON FUNCTION CREATION
%   =======================================================
%   I originally wanted to write this function to resolve:
%   'J Physiol USSR';
%
%   BETTER EXAMPLE:
%   The Annals of otology, rhinology, and laryngology
%   The Pitt resolver returned:
%   Eddington, D K (11/1978). "Auditory prostheses research with multiple channel 
%   intracochlear stimulation in man". Annals of otology, rhinology & laryngology 
%   (0003-4894), 87 (6), p. 1.
%
%   IMPROVEMENTS:
%   1) This function doesn't use JSOUP, works for now but could switch to
%   that instead ...
%
%
%   LIST OF ASSUMPTIONS
%   =========================================================================
%   1) 2 forms are present, first is actually commented out, we use the 2nd
%       - the form retrieval function doesn't ignore comments
%   2) Journal Title in bold (strong)
%   3) See patterns to match below

docStruct  = obj.j_obj;
formStruct = form_get(obj.SS_ADDRESS);

%POPULATION OF FORM AND DATA RETRIEVAL
%================================================
%NOTE: first form is commented out, second should exist
if length(formStruct) == 1
    error('Unexpected length for form, perhaps code changed, see website')
end
formStruct = formStruct(2); 
formStruct = form_helper_setTextValue(formStruct,'C',docStruct.journal);

[resultTxt,extras] = form_submit(formStruct); %#ok<NASGU>

%PROCESSING OF RESULTS TO GET OUTPUT
%================================================
%<span class="SS_ResultsCount">1 record</span>
pat1 = 'class="SS_ResultsCount">\s*(\d+)\s*record';
nRecords = str2double(regexpi(resultTxt,pat1,'tokens','once'));
if nRecords == 0 || isempty(nRecords)
    results = [];
    return
end

%NOTE: Could use html_getTagsByProp below
%<span class="SS_JournalTitle">
%<strong>Annals of otology, rhinology &amp; laryngology</strong>
%</span
pat2    = 'class="SS_JournalTitle".*?<strong>(.*?)</strong>';
jTitles = regexpi(resultTxt,pat2,'tokens','once');
jTitles = cellfun(@(x) html_encode_decode_amp('decode',x),jTitles,'UniformOutput',false);


%<span class="SS_JournalISSN">(0003-4894)</span>
pat3  = 'class="SS_JournalISSN">\((.*?)\)</span>';
jISSN = regexpi(resultTxt,pat3,'tokens','once');

results = struct('title',jTitles,'issn',jISSN);

