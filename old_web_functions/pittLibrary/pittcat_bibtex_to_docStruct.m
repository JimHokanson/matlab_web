function docStruct = pittcat_bibtex_to_docStruct(str)
%pittcat_bibtex_to_docStruct  Converts bibtex documents to the standard document struct
%
%   FORMS
%   =======================================================================
%   1)
%   docStruct = pittcat_bibtex_to_docStruct()
%   Copies string from clipboard
%
%   2)
%   docStruct = pittcat_bibtex_to_docStruct(str)
%
%   OUTPUTS
%   =======================================================================
%   docStruct
%
%   JAH TODO: Document function
%
%   NOTE: This is only meant to handle articles, although I don't currently
%   check that the str contains the leading @article identifier
%
%   EXAMPLE:
%   =======================================================================
%   Assume the following was copied onto the clipboard:
%   @article{andreev1935electrical,
%   title={On the electrical excitability of the human ear: On the effect of alternating currents on the affected auditory apparatus},
%   author={Andreev, AM and Gersuni, GV and Volokhov, AA},
%   journal={J Physiol USSR},
%   volume={18},
%   pages={250--265},
%   year={1935}
%   }
%


if nargin == 0
    str = clipboard('paste');
end

% @article{andreev1935electrical,
%   title={On the electrical excitability of the human ear: On the effect of alternating currents on the affected auditory apparatus},
%   author={Andreev, AM and Gersuni, GV and Volokhov, AA},
%   journal={J Physiol USSR},
%   volume={18},
%   pages={250--265},
%   year={1935}
% }


%NOTE: Make sure to have these two match in length
BIBTEX_FIELDS = {'title' 'author' 'journal' 'volume' 'pages' 'year' 'number' 'publisher' 'organization' 'booktitle' 'institution' ,'school'};
DOC_STRUCT_F  = {'title' 'authors' 'journal' 'volume' 'pages' 'year' 'issue' 'publisher' ''             'journal'   ''              ''};

%first get the field names and the values



%then have a field to docStruct matching

docStruct = pittcat_getJournalStruct;

%Grab main entry:
fieldEntries = regexp(str,'\s(?<field>\S+)={(?<value>.*?)}[,\n]','names');

allFields = {fieldEntries.field};

[isPresent,loc] = ismember(allFields,BIBTEX_FIELDS);
if ~all(isPresent)
   error('Unrecognized bibtex fields, please add to the list in the code'); 
end


for iField = 1:length(allFields)
    curNewField = DOC_STRUCT_F{loc(iField)};
    if strcmp(curNewField,'authors')
        docStruct.authors = regexp(fieldEntries(iField).value,' and ','split');
    elseif ~isempty(curNewField)
        docStruct.(curNewField) = fieldEntries(iField).value;
    end
    
end

docStruct = pittcat_cleanDocStruct(docStruct);