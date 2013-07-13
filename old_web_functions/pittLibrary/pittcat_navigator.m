
%@article{holle1984functional,
%   title={Functional electrostimulation of paraplegics; experimental investigations and first clinical experience with an implantable stimulation device},
%   author={Holle, J. and Frey, M. and Gruber, H. and Kern, H. and Stohr, H. and Thoma, H.},
%   journal={Orthopedics},
%   volume={7},
%   number={7},
%   pages={1145--60},
%   year={1984}
% }
%

%17691339 - ILL
%
%431509 - ILL

pittcat_client_gui.run



%DOCUMENT FORMATION OPTIONS
%=============================================
%1) From PUBMED
docStruct = pittcat_getJournalStructFromPubmed('8872891');
%2) Manually
docStruct = pittcat_getJournalStruct;
%3) From Google Scholar
docStruct = pittcat_bibtex_to_docStruct; %Copies from clipboard



%   IN ULS (GET OFF YOUR ASS)
%===================================
%   - 8509306 - Channel interactions in patients using the Ineraid multichannel cochlear implant
%   - 2016898 - sounds interesting




%UNABLE TO FIND
%=====================================
% - damn supplements 6588542

%FIXES TO DO:
%13034929 - journal resolver adds 1911, which then doesn't match
% had to remove leading article to fix ...
%- pass out docStruct from pittcat_checkStorage







%DETERMINE STORAGE OPTION
%=========================================================================
%Might want to add on logout before login ...
[options,storageInfo] = pittcat_checkStorage(docStruct);
%SHOULD I PASS OUT DOC_STRUCT as the journal name can be modded


%JAH TODO
%Need some logic in here for handling the options, if none or more than one

fileRequestID      = datestr(now,'yyyy_mm_dd_T_HH_MM_SS_FFF');
docStruct.rInfo    = struct('fileRequestID',fileRequestID,'option',options(1));
if isempty(storageInfo) || isempty(storageInfo.rank)
    docStruct.jStorage = docStruct.journal;
else
    docStruct.jStorage = storageInfo.rank(1).jTitle;
end

%DOCUMENT REQUEST
%==========================================================================
switch lower(options(1))
    case 'uls_storage'
        success = pittcat_requestUlsStorage(storageInfo.rank(1),docStruct);
    case 'hsls_storage'
        %email Marissa
        success = pittcat_request_hslsStorage(docStruct,'jimh@wustl.edu');
    case {'ill' 'inhsls'}
        success = pittcat_request_ILL(docStruct);
    case 'inuls'
end

if success
    pittcat_saveSuccessfulRequestToFile(docStruct)
end


%Still need to write to file
