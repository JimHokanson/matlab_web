function [output,otherStruct] = mendeley_pvt_doc_createEntry(authStruct,newEntry)
%mendeley_pvt_doc_createEntry
%
%   output = mendeley_pvt_doc_createEntry(authStruct,newEntry)
%   
%   OUTPUTS
%   =======================================================================
%   output (structure)
%       .document_id : string
%
%   INPUTS
%   =======================================================================
%   newEntry   : must contain the following fields:
%       .type
%       .title
%   The parameter .group_id may be included to add the document to a group
%
%   VALID_TYPES
%   ========================================================================
%   Bill, Book, Book Section, Case, Computer Program, Conference Proceedings, 
%   Encyclopedia Article, Film, Generic, Hearing, Journal Article, Magazine Article, 
%   Newspaper Article, Patent, Report, Statute, Television Broadcast, Thesis, Web Page, Working Paper
%
%   VALID FIELDS
%   ========================================================================
%   'title', 'type', 'authors', 'volume', 'issue', 'url', 'doi', 'pmid', 
%   'tags', 'notes', 'keywords', 'pages', 'year', 'publisher', 'abstract', 
%   'isbn', 'issn', 'country', 'genre'
%
%   EXAMPLE
%   =======================================================================
%   newEntry = struct;
%   newEntry.title = 'This is a test';
%   newEntry.type  = 'Journal Article';
%   newEntry.year  = '2006';
% 
%   #doc_page: http://apidocs.mendeley.com/home/user-specific-methods/user-library-create-document
%
%   See Also: 

%JAH TODO: Do more error checking here

VALID_FIELDS = {...
      'title', 'type', 'authors', 'volume', 'issue', 'url', 'doi', 'pmid', ... 
  'tags', 'notes', 'keywords', 'pages', 'year', 'publisher', 'abstract', ...
  'isbn', 'issn', 'country', 'genre'};


url = 'http://api.mendeley.com/oapi/library/documents/';
httpMethod = 'POST';

jDoc = mat2json(newEntry);

myParamsPE = {'document',jDoc};

[output,otherStruct] = mendeley_helper_retrieval(httpMethod,url,authStruct,myParamsPE,false);