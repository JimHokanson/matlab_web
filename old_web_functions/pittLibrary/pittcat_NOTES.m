function pittcat_NOTES
%
%
%NEXT STEP
%----------------------------------------------------
%Finish Google Scholar search with Bibtex
%   - requires preferences
%   - create new urlread with headers -> curl?
%
%STILL TO DO
%--------------------------------------------------------------------------
%Create interface for adding doc to Mendeley and updating request records
%Check on pages, make sure they are not a supplement
%Match to what's in Mendeley - both mine and others 
%Extract citation from selection
%Add warning when year is way off but volume matches

%PERSONAL INFORMATION
%================================================
%info = pittcat_getUserInfo

%STEPS
%==============================================
%1) Form docGetStruct from selection (i.e. what do you want)
%   - If from journal article
%       - Build GUI Interface
%       - Create rules for each journal THIS WILL BE TRICKY
%   -DONE If from pubmed search, pumbed_getDocStructFromPMID(pmid)
%
%2) Fill in missing information, from web search
%       -> do google scholar search with Bibtex citation, complete
%       -DONE or try pubmed search, pubmed_search
%
%3) Check whether or not document is in local collection
%       - get all documents in local collection
%           # lib = mendeley_local_getLibrary(USER_NAME,forceReloadAll)
%           # pittcat_checkLocalCollection
%       - finish function citationMatch
%
%4) Check if available online, fill out form to get?
%       - IN_PROGRESS pittcat_performCitationSearch
%           # pittcat_performCitationSearch(docGetStruct)
%
%5) STARTED Check storage options
%      - Resolve journal
%      - check valid entries
%      - bring up result for disambiguation -> web browser in gui?
%      - go through all options, verify presence or absence
%6) DONE Make appropriate request
%      DONE Pitt Storage
%      DONE HSLS Storage - email Marissa
%      DONE Not available - ILL Request
%      - Available at library - damn
%7)

%FUCNTIONS
%====================================================================
%pittcat_checkExpiration - DONE - checks for expired PittCat session
%getDocStructFromPMID