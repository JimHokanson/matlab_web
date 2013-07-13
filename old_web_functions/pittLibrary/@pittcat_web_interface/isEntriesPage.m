function [flag,nEntries] = isEntriesPage(raw_text)
%isEntriesPage Determines if search yielded multiple results
%
%   [flag,nEntries] = isEntriesPage(raw_text)
%
%   Determines whether multiple entries are present
%   If that is the case, then this page's text will contain a table
%   with columns that vary depending on the type of search performed
%
%
%   3 outcomes:
%   1) no results, flag = false, nEntries = 0
%   2) only 1 result, straight to page, flag = false, nEntries = 1
%   3) more than 1 result, flag = true, nEntries > 1
%

NO_JOURNALS_FOUND_TEXT = 'Your search was not successful'; 

N_ENTRIES_PROCEEDING_TEXT = 'Displaying 1 '; %NOTE SPACE FOLLOWING 1

%Determining # of entries

flag = true;

if ~isempty(strfind(raw_text,NO_JOURNALS_FOUND_TEXT))
    flag  = false;
    nEntries = 0;
    return
end

nEntries = str2double(regexp(raw_text,['(?<=' N_ENTRIES_PROCEEDING_TEXT ')(?:[^\d]*?)(\d+)'],'tokens','once'));

if nEntries == 1
    flag = false;
end