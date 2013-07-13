function success = pittcat_request_hslsStorage(docStruct,ccEmail)
%
%
%   TODO
%   =========================================================
%   1) DONE replace journal with rankInfo entry
%   2) save to file
%   3) DONE add cc
%   4) DONE add random # for tracking?
%

dS = docStruct;
VERSION = '1.0';
DEL_HIST = false;
info = pittcat_getUserInfo;

recipient = struct;
recipient(1).address = 'mai7@pitt.edu';
%recipient(1).address = 'jim.hokanson@gmail.com'; %Eventually to Marisa
recipient(1).type = 'TO';
recipient(2).address = 'rnel.papers@gmail.com';
recipient(2).type = 'CC';
if exist('ccEmail','var')
    recipient(3).address = ccEmail;
    recipient(3).type = 'CC';
end
% recipient(3).address = info.login.email;
% recipient(3).type = 'CC';

subject   = ['[HSLS_Storage_Request] ' info.login.requestor ' - ' dS.rInfo.fileRequestID];
sender = 'rnel.papers@gmail.com';
passwd = info.login.gpas;

L1 = 'Please request the following article from HSLS Storage';
L2 = 'Link: http://www.hsls.pitt.edu/services/documentdelivery';
pmid = docStruct.pmid;
if ~isempty(pmid)
    L3 = sprintf('\nPubmed ID: %s',pmid);
else
    L3 = sprintf('\nPubmed ID: Not Available');
end

%authors = cellArrayToString(dS.authors,' ');
if ~isempty(dS.authors)
    firstAuthor = dS.authors{1};
else
    firstAuthor = '';
end
L4 = sprintf(['\nJournal: %s\nTitle: %s\nFirst Author: %s\nVolume: %s'...
    '\nIssue: %s\nYear: %s\nPages: %s\n'],dS.jStorage,dS.title,firstAuthor,...
    dS.volume,dS.issue,dS.year,dS.pages);

L5 = sprintf('Requestor: %s',info.login.requestor);
L6 = sprintf('Email: %s', info.login.email);
L7 = sprintf('Automated Request, VERSION %s',VERSION);
L8 = sprintf('ID: %s',dS.rInfo.fileRequestID);

Lall = {L1 L2 L3 L4 L5 L6 L7 L8};

message = cellArrayToString(Lall,'\n',false);

success = gmail(recipient,subject,message,sender,passwd,DEL_HIST);
