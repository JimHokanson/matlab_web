function parseInitJournalSearch(obj)
%
%
%   parseInitJournalSearch(obj)
%
%   POPULATES
%   ============================================
%   .nInitJournalsFound
%   .init_journal_results (struct)
%         .jTitle
%         .full_title
%         .pubInfo
%         .LibSystem
%         .jLink
%   .raw_page_text         
%
%   IMPROVEMENTS
%   1) Switch to using JSOUP - low priority
%
%   OUTLINE
%   ===============================================================
%   At this point we've searched for a journal and gotten a page
%   that has given us a result. We don't know what that page contains yet.
%   It could be one of two formats. Most often it is a table listing
%   a bunch of journal options that match our desired journal, with links
%   to details about what each journal option contains. Sometimes
%   if we only have one result the server will automatically forward us
%   to the result page for the single journal option match.



%CONSIDER REWORKING USING ::::: 
%[nEntries,s] = pittcat_web_interface.parseEntriesPage(raw_text,prev_url)




raw_text = obj.init_journal_search_text;

ROUGH_TABLE_START   = '<TH>#</TH>';
N_ENTRIES_PROCEEDING_TEXT = 'Displaying 1 '; %NOTE SPACE FOLLOWING 1

%Determining # of entries
nEntries = str2double(regexp(raw_text,['(?<=' N_ENTRIES_PROCEEDING_TEXT ')(?:[^\d]*?)(\d+)'],'tokens','once'));

obj.nInitJournalsFound = nEntries;

obj.no_journal_results_bug = nEntries == 1;

if obj.no_journal_results_bug
    %ALREADY AT NEXT PAGE
    %- only one result was found, thanks for the shortcut :/
    obj.raw_page_texts = {raw_text};
    obj.prev_urls      = {obj.init_search_result_url};
else
    
    %FINDING THE START AND STOP OF EACH RESULT
    %--------------------------------------------------------------------------
    %This is actually just a rough first part trim
    I_start = strfind(raw_text,ROUGH_TABLE_START);
    
    if isempty(I_start)
        error('Failed to find start of the search table')
    end
    
    temp2 = raw_text(I_start:end);
    %NOTE: Each entry is actually a table inside of the table
    I_end = strfind(temp2,'</TABLE');
    temp2 = temp2(1:I_end(nEntries + 1));
    
    %This indicates the start of the tables
    I_tableStart = strfind(temp2,'<TD ALIGN=LEFT ROWSPAN=2 nowrap>');
    %error check -> I_tableStart is length nEntries
    I_tableStart = [I_tableStart length(temp2)+1];
    
    
    %Now we go through each sub table, and pull out the text, as well
    %as the link information that is needed to follow the submission
    %---------------------------------------------------------------------
    allText = cell(nEntries,4);
    allHref = cell(nEntries,4);
    for iEntry = 1:nEntries
        tempText   = temp2(I_tableStart(iEntry):I_tableStart(iEntry+1)-1);
        I_colStart = strfind(tempText,'<TD ALIGN=LEFT>');
        %error check -> I_colStart is length 4
        I_possEnd  = strfind(tempText,'</TD>');
        for iCol = 1:4
            endIndex = find(I_possEnd > I_colStart(iCol),1);
            tdEntry = tempText(I_colStart(iCol):I_possEnd(endIndex));
            %get all text with HREF=" proceeding it until
            %the " sign is encountered
            %Then grab as much as possible until the first > is encountered
            %but don't keep it
            %Then grab all text until the next < character
            tempCA  = regexp(tdEntry,'(?<=HREF=")([^"]*).*?>([^<]*)','tokens','once');
            if length(tempCA) == 2
                allText{iEntry,iCol} = tempCA{2};
                allHref{iEntry,iCol} = tempCA{1};
            else
                allText{iEntry,iCol} = '';
                allHref{iEntry,iCol} = '';
            end
        end
    end
    
    obj.init_journal_results = struct(...
        'jTitle',       allText(:,1),...
        'full_title',   allText(:,2),...
        'pubInfo',      allText(:,3),...
        'LibSystem',    allText(:,4),...
        'jLink',        allHref(:,2));
    
    
    
end