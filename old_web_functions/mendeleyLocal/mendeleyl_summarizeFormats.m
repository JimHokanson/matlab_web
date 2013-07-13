%function mendeleyl_summarizeFormats(lib)

%1) Grab type
%2) For each unique type, grab all unique fields
%3) For each document, declare if fields have data or not

entries = lib.entries;
allTypes = cellstructGetField(entries,'type','');

[uTypes,uTypes_I] = unique2(allTypes);

nDocTypes = length(uTypes);

uFieldsSummary = cell(1,nDocTypes);
allSummaries   = cell(1,nDocTypes);

for iType = 1:nDocTypes
   curDocType = uTypes{iType};
   fn = cellfun(@fieldnames,entries(uTypes_I{iType}),'un',0);
   allFieldNames = unique(vertcat(fn{:}));
   
   uFieldsSummary{iType} = allFieldNames;
   
   curDocTypeIndices = uTypes_I{iType};
   
   
   
   %For each field, create entry for each
   summaryLocal = cell(length(curDocTypeIndices)+1,length(allFieldNames));
   summaryLocal(1,:) = allFieldNames;
   
   for iDoc = 1:length(curDocTypeIndices)
      curIndex = curDocTypeIndices(iDoc);
      curDoc   = entries{curIndex};
      for iField = 1:length(allFieldNames)
         curField = allFieldNames{iField};
         if isfield(curDoc,curField)
             summaryLocal{iDoc+1,iField} = curDoc.(curField);
         else
             summaryLocal{iDoc+1,iField} = '';
         end
      end
   end
   allSummaries{iType} = summaryLocal;
end