function parseEntries(obj,indicesToParse)
%
%   JAH TODO: Document method
%
%   method was separated from getLibrary to make updating easier



for iEntry = indicesToParse
    
    curEntry = obj.entries{iEntry};
    s        = parseEntry(curEntry); %Static call
    
    obj.title{iEntry}       = s.title;
    obj.authors{iEntry}     = s.authors;
    obj.year(iEntry)        = s.year;
    obj.publication{iEntry} = s.publication;
    obj.docType{iEntry}     = s.docType;
end

end

function s = parseEntry(curEntry)
%parseEntry
%
%   parseEntry 
%
%   s = parseEntry(~,curEntry)
%
%   Move into helper function of parseEntries
%

    s.docType  = curEntry.type;
    
    if isfield(curEntry,'title')
        s.title    = curEntry.title;
    else
        s.title = '';
        formattedWarning('Title missing: %d',iEntry);
    end
    
    if isfield(curEntry,'authors')
        tempAuthors  = curEntry.authors;
        tempAuthors2 = cellstructGetField(tempAuthors,'surname','');
        %s.authors   = cellArrayToString(lower(tempAuthors2),':');
        s.authors    = lower(tempAuthors2);
    else
        s.authors    = {};
        formattedWarning('Authors missing: %d',iEntry);
    end
    
    if isfield(curEntry,'year')
        s.year = str2double(curEntry.year);
    else
        s.year = 0;
    end
    
    if isfield(curEntry,'publication_outlet')
        %Not present for books, maybe others
        s.publication = curEntry.publication_outlet;
    else
        s.publication = '';
    end
    
end