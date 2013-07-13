function output = pittcat_performCitationSearch(docStruct)
%pittcat_performCitationSearch
%
%   Goal: Implement the search function
%
%   POSSIBLE OUTCOMES
%   ==============================================================
%   output.optionStr = 'Redirect To Source';
%   output.option    = 1;
%   output.finalRedirectURL =>
%   
%   

%STATUS OF THIS FILE
%====================================
%Able to follow result to an online file
%Don't currently handle the multitude of result options very well
%Not sure what is all possible ...


BAD_STRING = 'Sorry, this item might be unavailable here';

URL = 'http://rt4rf9qn2y.search.serialssolutions.com/?SS_Page=refiner&SS_RefinerEditable=yes';
formStruct = form_get(URL);

%================================
%Article Title
formStruct = form_helper_setTextValue(formStruct,'rft.atitle',docStruct.title);
%Journal
formStruct = form_helper_setTextValue(formStruct,'rft.title',docStruct.journal);
%Volume
formStruct = form_helper_setTextValue(formStruct,'rft.volume',docStruct.volume);
%Issue
formStruct = form_helper_setTextValue(formStruct,'rft.issue',docStruct.issue);
%ISSN
formStruct = form_helper_setTextValue(formStruct,'rft.issn',docStruct.issn);
%Page
formStruct = form_helper_setTextValue(formStruct,'rft.spage',docStruct.pages);
%Date
formStruct = form_helper_setTextValue(formStruct,'rft.date',docStruct.year);
% % %AuthorLast
% % formStruct = form_helper_setTextValue(formStruct,'rft.aulast',docGetStruct.journal);
% % %AuthorFirst
% % formStruct = form_helper_setTextValue(formStruct,'rft.aufirst',docGetStruct.journal);
%DOI
formStruct = form_helper_setTextValue(formStruct,'SS_doi',docStruct.doi);
%PMID
formStruct = form_helper_setTextValue(formStruct,'pmid',docStruct.pmid);


[web_page_text,extras] = form_submit(formStruct);

prevURL = URL;

%302, moved temporarily - follow the rabbit ...
%==========================================================================
allHeaders = extras.allHeaders;
status     = extras.status;
while status.value == 302
    prevURL = allHeaders.Location;
   [web_page_text,allHeaders,status] = urlread2(prevURL);
end
    
%CHECK FOR META-REFRESH
%==========================================================================
%<meta http-equiv="refresh" content="0;url='./log?L=RT4RF9QN2Y&amp;D=HLW&amp;J=BIOCMED&amp;U=http%3A%2F%2Fwww.sciencedirect.com%2Fscience%3F_ob%3DGatewayURL%26_origin%3DSERIALSSOL%26_method%3DcitationSearch%26_volkey%3D00062944%252313%2523117%25232%26_version%3D1%26md5%3Def8c4cd85bc383d31e54e42791ef545c&amp;O=set'" />

[mStart,mEnd] = regexp(web_page_text,'<meta .*?>','start','end');
for iMeta = 1:length(mStart)
metaTag = html_getAttributesTag(web_page_text(mStart(iMeta):mEnd(iMeta)));
    if isfield(metaTag,'http_equiv') && strcmpi(metaTag.http_equiv,'refresh')
       %get link 
       tempRelLink = deref(regexpi(metaTag.content,'url=''([^'']*)','tokens','once'));
       tempRelLink = html_encode_decode_amp('decode',tempRelLink);
       nextURL = url_getAbsoluteUrl(prevURL,tempRelLink);
       [~,allHeaders,status] = urlread2(nextURL);
       if status.value ~= 302
           error('Expected the request to return a server relocate request')
       end
       output = struct;
       output.optionStr = 'Redirect To Source';
       output.option    = 1;
       output.finalRedirectURL = allHeaders.Location;
       return
    end
end

keyboard

%WHAT ELSE MIGHT HAPPEN

%OPTIONS
%======================
%1) redirect to outside page
%2) 


%1) Might be bad string
%2) Might return 302, 303, 
%3) 

%If available click “article” link. If not click “issue home” or “journal home” link .

%ArticleCL
%JournalCL


%NOTE: In the case below we really care about the value
%of the <a> tag in JournalCL
%  <td valign="middle" align="center" width="10%" class="ResultsRow">
% <div id="ArticleCL" class="cl" />
% </td>
% <td valign="middle" align="center" width="10%" class="ResultsRow">
% <div id="JournalCL" class="cl">
% <a target="_blank" href="./log?L=RT4RF9QN2Y&amp;D=HR1&amp;J=HEARRES&amp;U=http%3A%2F%2Fpittcat.pitt.edu%2Fcgi-bin%2FPwebrecon.cgi%3FDB%3Dlocal%26SL%3Dnone%26Search_Arg%3DHearing%2520research%26Search_Code%3DJALL%26CNT%3D50">Journal home</a>
% </div>
% </td>
% <td valign="middle" width="30%" class="ResultsRow">
% <div id="DateCL" class="cl">
% </div>
% </td>
% <td valign="middle" width="50%" class="ResultsRow">
% <div id="DatabaseCL" class="cl">
% <span class="SS_DatabaseSource">Print volumes in the library</span>
% </div>
% </td>


%http://rt4rf9qn2y.search.serialssolutions.com/?
%sid=sersol%3ARefinerQuery
%&url_ver=Z39.88-2004
%&l=RT4RF9QN2Y
%&SS_ReferentFormat=JournalFormat
%&rft.date=1987
%&rft.genre=article
%&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal
%&rft.title=Nature
%&rft.volume=330
%&citationsubmit=Find+Full+Text
%&SS_LibHash=RT4RF9QN2Y
%&rfr_id=info%3Asid%2Fsersol%3ARefinerQuery

%ADDED A FEW MORE OPTIONS
%http://rt4rf9qn2y.search.serialssolutions.com/?
%sid=sersol%3ARefinerQuery
%&rft.aulast=GIRDLER
%&url_ver=Z39.88-2004
%&l=RT4RF9QN2Y
%&rft.date=1987
%&SS_ReferentFormat=JournalFormat
%&rft.genre=article
%&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal
%&rft.atitle=Structure+and+evolution+of+the+northern+Red+Sea
%&rft.spage=716
%&rft.title=Nature
%&rft.volume=330
%&citationsubmit=Find+Full+Text
%&rfr_id=info%3Asid%2Fsersol%3ARefinerQuery
%&SS_LibHash=RT4RF9QN2Y
%&rft.aufirst=R