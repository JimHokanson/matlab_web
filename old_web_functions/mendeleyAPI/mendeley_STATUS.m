%NOTES FOR MENDELEY
%==========================
%create document - title, title expected to be a string not an array, bad request
%delete document - change to indicate 204 is good
%      - group documents should be deleted with group method ???

%NAMING CONVENTIONS
%==========================
%mendeley_pvt   - private mendeley functions
%mendeley_pub   - public mendeley functions
%mendeley2      - simple wrappers on these functions which expand functionality
%mendeley_local - functions that rely on upon user storage

%BEST PRACTICES
%==========================================================================
%IN FUNCTIONS:
%   - use mendeley_helper_retrieval  
%
%DOCUMENTATION:
%   -  prettyPrintJSON - for uploading to Mendeley website



%USAGE BY USER
%==========================================================================
%mendeley_local_getAuthStruct - use to retrieve authorization struct

%ASSUMPTIONS
%==========================================================================
%1) local Mendeley ids can be stored as doubles (default is sent as string)
%   I NEED TO WORK ON NAILING THIS ON THE SPECIFICATION



%BELOW IS OUT OF DATE ...

%API LIST
%==========================================================================
%PUBLIC RESOURCES
%========================================
%STATS METHODS
%-------------------------------
%   mendeley_pub_stats
%authors:       authors (stats-authors.htm)
%papers:        papers (stats-papers.htm)
%publications:  publications (stats-publication-outlets.htm)
%tags:          tags (stats-tags.htm)
%
%SEARCH METHODS
%-------------------------------
%   mendeley_pub_search
%search:     terms (search-terms.htm)
%document_details: details (search-details.htm)
%related:    related (search-related.htm)
%authored:   authored (search-authored.htm)
%tagged:     tagged (search-tagged.htm)
%categories: categories (search-categories.htm)
%subcategories:    subcategories (search-subcategories.htm)
%
%PUBLIC GROUP METHODS
%-------------------------------
%   mendeley_pub_groups
%search: search  (search-public-groups.htm)
%details: details (missing)
%documents: documents (public-groups-documents.htm)
%people: people (public-groups-people.htm)
%
%PRIVATE_RESOURCES
%============================================================
%STATS METHODS
%-----------------------------------
%   mendeley_pvt_stats
%Author Stats:
%Tag Stats:
%Pub. Stats:
%
%DOCUMENT METHODS
%-----------------------------------
%   mendeley_pvt_doc_
%Library: library
%Auth. Pub: authored
%Doc. Details: details
%Create New Doc: createEntry
%Upload File:
%Down. File
%Delete Doc: 
%
%GROUP METHODS
%-----------------------------------
%   mendeley_pvt_group
%Groups: list
%Group people:
%Group Docs:
%Group Doc. Details:
%Create Group:
%Delete Group:
%
%FOLDERS METHODS
%-----------------------------------
%   mendeley_pvt_folder
%Folders
%Folder Docs:
%Add Doc To Folder:
%Create Folder:
%Delete Folder: 
%Delete Doc From Folder: _rem_doc
%
%PROFILE METHODS
%-----------------------------------
%   mendeley_pvt_profile
%Contacts:
%Add Contact:
%Profile Info:
