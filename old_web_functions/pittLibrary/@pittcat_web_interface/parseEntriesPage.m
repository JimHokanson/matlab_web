function [headers,text_ca,links] = parseEntriesPage(raw_text,prev_url,nEntries)
%
%       [nEntries,s] = pittcat_web_interface.parseEntriesPage(raw_text,prev_url)
%
%   This is a generic interface for parsing a search results page. No
%   assumptions are made about the specific content of the search result,
%   as this can vary depending on the type of search performed. Only the
%   rough format of the search result table is assumed. See assumptions in
%   code.
%
%   OUTPUTS
%   ================================
%   headers : title of each column in the table
%   links   : one for each result, value returned is absolute URL
%   text_ca : [result x columns], the results are actually multi-row 
%             so all results on the 2nd row can be found after the first
%             n columns, where n is equal to the # of headers
%
%
%
%   See Also:
%       [flag,nEntries] = pittcat_web_interface.isEntriesPage(web_page_text);
%

if nEntries < 2
    error('This function should not be called for 0 or 1 result')
end

TABLE_SELECTOR_INDEX = 0;
N_TABLE_TAGS = 2;
%FORMAT:

doc_obj    = jsoup_get_doc(raw_text,prev_url);
table_tags = doc_obj.select('table:has(th)');

%ASSUMPTION
if table_tags.size ~= N_TABLE_TAGS
   error('Expected two tables with headers') 
end

%ASSUMPTION
table_obj = table_tags.get(TABLE_SELECTOR_INDEX);

%HEADER PARSING -----------------------------
header_tags = table_obj.getElementsByTag('th');
nHeaders = header_tags.size;
headers = cell(1,nHeaders);
for iHeader = 1:nHeaders
   headers{iHeader} = char(header_tags.get(iHeader-1).text);  
end

%ASSUMED ROW FORMAT
%two rows per entry, the first one has a # that spans both rows
%both rows have column entries for the other headers
%so in total, 2*(nHeaders-1) + 1 for the #, or alternatively 2*nHeaders - 1
%since the # only occupies 1 row, not two
td_tags  = table_obj.select('td:not(:has(td))');

nTD = td_tags.size;

text_ca  = cell(nEntries,nHeaders*2-1);
links = cell(1,nEntries);

curIndex = 0;
for iRow = 1:nEntries
    for iCol = 1:(nHeaders*2-1)
        
        if curIndex == nTD - 1
            return
        end
        
        td_obj   = td_tags.get(curIndex);
        row_span = td_obj.hasAttr('rowspan');
        
        if iCol == 1 && ~row_span
            error('Error parsing, it is assumed that a # spans two rows with rowspan')
            %NOTE: I don't currently test = 2
        elseif row_span && iCol ~= 1
            %go onto the next one
            break
        else
            curIndex = curIndex + 1;
            text_ca{iRow,iCol} = char(td_obj.text);
            
            %ASSUMPTION: All the links are the same ...
            if ~isempty(links(iRow))
                a_tags = td_obj.getElementsByTag('a');
                if a_tags.size > 0
                   links{iRow} = char(a_tags.get(0).absUrl('href'));   
                end
            end
        end
    end
    if iRow~= nEntries && iCol ~= (nHeaders*2-1) && ~row_span
       %pittcat_client.show_page(raw_text)
       error('table format assumption violated') 
    end
end

