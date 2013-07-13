function [inLocal,otherInfo] = pittcat_checkLocalCollection(username,docStruct,varargin)
%
%   This 
%

%Do we make an assumption about the document being a journal?
%For now, yes ...

DEFINE_CONSTANTS

END_DEFINE_CONSTANTS

lib = mendeley_local_getLibrary(username,forceReloadAll);

p_match = zeros(1,length(lib));
for i_Entry = 1:length(lib)
    
end