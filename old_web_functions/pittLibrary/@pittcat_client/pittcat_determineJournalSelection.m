function journalSel = pittcat_determineJournalSelection(jStruct_or_text,prevURL,docGetStruct,varargin)
%pittcat_determineJournalSelection
%
%   Given a variety of journal links, this bit of code goes through each
%   page and determines if that page contains the article of interest
%
%   CALLING FORMS
%   =======================================================================
%   NORMAL MODE
%   --------------------------------
%   [options,rankInfo] = pittcat_determineJournalSelection(journalMatches,docGetStruct)
%
%   IF ONLY ONE MATCH IS FOUND
%   ------------------------------------------------
%   [options,rankInfo] = pittcat_determineJournalSelection(webText,docGetStruct)
%
%   OUTPUTS
%   =======================================================================
%   options: ranked a rray of which options are available, normally only
%            a single value tends to be returned, valid values are:
%       'uls_storage'   - 
%       'hsls_storage'  -
%       'in_uls'        - present in the library
%       'in_hsls'       - "                    "
%       'ill'           - not available, need to request via interlibrary loan
%   rankInfo:
%   allEntries:     
%   
%   See Also:
%       pittcat_parseJournalSearch
%       pittcat_parseJournalSearchPart2
%       pittcat_parseJournalEntry
%       pittcat_checkStorage

OPTIONS_MAIN = {'uls_storage' 'hsls_storage' 'in_hsls' 'in_uls' 'ill'};

%Form rank preference
%==================================================================
rankOrder = {'ULS Storage' '' ...
             'HSLS Storage' '' ...
             '' 'Health Sciences Library System' ...
             '' 'ULS: Pittsburgh Campus' ...
             '' ''};
         
specificRank = rankOrder(1:2:end);
generalRank  = rankOrder(2:2:end);

%Essentially what this says is my preffered order is:
%1) From ULS storage  - fill out form, receive soon
%2) From HSLS storage - email Marissa, receive soon
%3) HSLS - fill out interlibrary loan (ILL), hopefully receive soon
%4) ULS  - if present, I need to get off my butt to get it
%5) Finally, if it doesn't match these, I can do an ILL
%This is reflected in the order of OPTIONS_MAIN

%Processing of the Journal Entry Page
%==========================================================================
if ischar(jStruct_or_text)
    web_str = jStruct_or_text;
    
    % -------
    matchAll = pittcat_parseJournalEntry(web_str,docGetStruct);
    [matchAll.iEntry] = deal(1);
    [matchAll.jURL]   = deal(prevURL);
    newURL = prevURL;
else
    jStruct = jStruct_or_text;
    for iEntry = 1:length(jStruct)
        newURL = url_getAbsoluteUrl(prevURL,jStruct(iEntry).jLink);
        
        % -------
        matchOptions = pittcat_parseJournalEntry(newURL,jStruct(iEntry).LibSystem,docGetStruct);
        [matchOptions.iEntry] = deal(iEntry);
        [matchOptions.jURL]    = deal(newURL);
        if iEntry == 1
            matchAll = matchOptions;
        else
            matchAll = [matchAll matchOptions]; %#ok<AGROW>
        end
    end
end

for iMatch = 1:length(matchAll)
   matchAll(iMatch).getItLink = url_getAbsoluteUrl(newURL,matchAll(iMatch).getItLink);
end

allEntries = matchAll;

%RANKING OF THE RESULTS
%==========================================================================
mf = find([matchAll.matchFound]);
qm = find([matchAll.quasiMatch]);

nFound = length(mf);
if nFound == 0
    nFound = length(qm);
    mf = qm;
    if nFound ~= 0 
    formattedWarning('Resorting to quasi matches')
    end
end

if nFound == 0
    %Let's check other things, prompt for input
    options = {'ill'};
    rankInfo = [];
    journalSel = struct;
    journalSel.options = options;
    journalSel.rankInfo = rankInfo;
    journalSel.allEntries = allEntries;
    return
end

matchesUse = matchAll(mf);

specificLocation = {matchesUse.specLocation};  %This is the specific library, like Langley or Hillman
generalLocation  = {matchesUse.genLocation}; 

rank_order = zeros(1,length(matchesUse));
for iRank = 1:length(matchesUse)
   rank_order(iRank) = find( ...
       cellfun(@(x) strncmp(x,specificLocation{iRank},length(x)),specificRank)...
       & ...
       cellfun(@(x) strncmp(x,generalLocation{iRank},length(x)),generalRank)...
       ,1);
end

%NOW, Let's resort on those found
[rank_order,I] = sort(rank_order);

rankInfo = matchesUse(I);
options  = OPTIONS_MAIN(rank_order);

journalSel = struct;
journalSel.options = options;
journalSel.rankInfo = rankInfo;
journalSel.allEntries = allEntries;



