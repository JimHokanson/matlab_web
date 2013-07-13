%function mendeleyl_addBook(bookDir)

%FIELDS TO DEFINE
%-----------------------------
%editors
%isbn
%book title
%- for each section, chapter title, authors

obj = mendeley_client('JAH');

book_title = 'Handbook of Neuroprosthetic Methods';
editors = {'Finn, WE' 'LoPresti, PG'};
all_chapters = 0:5;
year    = '2003';

%doi
%isbn
identifiers = struct( ...
    'isbn', '0849311104');

for iChapter = 1:length(all_chapters);
    cur_chapter = int2str(all_chapters(iChapter));
    s = struct;
    s.type         = 'Book Section';
    s.published_in = book_title;
    s.editors      = editors;
    s.chapter      = cur_chapter;
    s.identifiers  = identifiers;
    s.title        = ['Chapter' cur_chapter];
    s.year         = year;
    s.hide         = '0';
    
    %mendeley_pvt_doc_createEntry(obj.auth_struct,s);
end

book_title = 'Example Book';
editors = {'thing one' 'thing two'};
all_chapters = 1;
year    = '2000';

%doi
%isbn
identifiers = struct( ...
    'isbn', '978-0-7172-6059-1');

for iChapter = 1:length(all_chapters);
    cur_chapter = int2str(all_chapters(iChapter));
    s = struct;
    s.type         = 'Book Section';
    s.published_in = book_title;
    s.editors      = editors;
    s.chapter      = cur_chapter;
    s.identifiers  = identifiers;
    s.title        = ['Chapter' cur_chapter];
    s.year         = year;
    
    mendeley_pvt_doc_createEntry(obj.auth_struct,s);
end
