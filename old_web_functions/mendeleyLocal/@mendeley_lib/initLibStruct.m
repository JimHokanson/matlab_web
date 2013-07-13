function initLibStruct(obj,nEntries)
%mendeley_local_initLibStruct  Returns a libStruct
%
%   mendeley_local_initLibStruct(obj,nEntries)

obj.entries     = cell(1,nEntries);
obj.ids         = zeros(1,nEntries);
obj.lastRead    = zeros(1,nEntries);
obj.created     = zeros(1,nEntries);
obj.title       = cell(1,nEntries);
obj.authors     = cell(1,nEntries);
obj.year        = zeros(1,nEntries);
obj.publication = cell(1,nEntries);
obj.docType     = cell(1,nEntries);



