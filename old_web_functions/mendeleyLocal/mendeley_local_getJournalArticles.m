function allJournals = mendeley_local_getJournalArticles(USER_NAME,varargin)

USER_NAME = 'JAH';
forceReloadAll = false;
JOURNAL_TYPE = 'Journal Article';

% DEFINE_CONSTANTS
% forceReloadAll = false;
% END_DEFINE_CONSTANTS

lib = mendeley_local_getLibrary(USER_NAME,forceReloadAll);

type = cellfun(@(x) x.type,lib.entries,'UniformOutput',false);

isJournal  = strcmpi(JOURNAL_TYPE,type);
I_Journals = find(isJournal);
nJournals  = length(I_Journals);

docStruct = pittcat_getJournalStruct;
allJournals = repmat(docStruct,[1 nJournals]);

pat = '[A-Z]{2}$|\<[A-Z]';
for iJournal = 1:nJournals
    curEntry = lib.entries{I_Journals(iJournal)};
    allJournals(iJournal).title   = curEntry.title;
    
    if isfield(curEntry,'volume')
        allJournals(iJournal).volume  = curEntry.volume;
    else
        allJournals(iJournal).volume  = '';
    end
    
    if isfield(curEntry,'issue')
        allJournals(iJournal).issue   = curEntry.issue;
    else
        allJournals(iJournal).issue   = '';
    end
    
    if isfield(curEntry,'pages')
        allJournals(iJournal).pages = curEntry.pages;
    else
        allJournals(iJournal).pages = '';
    end
    
    if isfield(curEntry,'year')
        allJournals(iJournal).year    = curEntry.year;
    else
        allJournals(iJournal).year    = '';
    end
    
    if isfield(curEntry,'published_in')
        allJournals(iJournal).journal = curEntry.published_in;
    else
        allJournals(iJournal).journal = '';
    end
    
    
    if isfield(curEntry,'authors')
        authorsTemp = curEntry.authors;
        authors = cell(1,length(authorsTemp));
        
        for iAuthor = 1:length(authors)
            curAuthor = authorsTemp{iAuthor};
            %E E
            %EE
            %Eeee E
            tempMatch = regexp(curAuthor.forename,pat,'match');
            authors{iAuthor} = [curAuthor.surname ' ' tempMatch{:}];
        end
        
        allJournals(iJournal).authors = authors;
    else
        allJournals(iJournal).authors = {''};
    end
    
    
    
    identifiers = curEntry.identifiers;
    if isstruct(identifiers)
        if isfield(identifiers,'pmid')
            allJournals(iJournal).pmid = identifiers.pmid;
        end
        
        if isfield(identifiers,'issn')
            allJournals(iJournal).issn = identifiers.issn;
        end
        
        if isfield(identifiers,'doi')
            allJournals(iJournal).doi = identifiers.doi;
        end
    end
    
end