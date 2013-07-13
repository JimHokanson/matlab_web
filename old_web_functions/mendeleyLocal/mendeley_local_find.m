function mendeley_local_find(str,lib,varargin)

%How I want these strings to work
%Limit to author, year, journal name, title
%Allow specification via value pairs
%How to match searches?
% 'holsheimer 1997'
% 'iles 2005 simple'

%OTHER IMPORTANT FUNCTIONS
%lib = mendeley_local_getLibrary(USER_NAME,varargin)
%


%return a list that is ranked

%regexp then count hits???? (word1|word2|word3|word4)
%bag of words inputs first???

%Need gui & code for automatic extraction

%alphabetic count matching to limit

%a:
%y:
%p:
%t:
%g:

pat = 'a:.*?|y:.*?|p:.*?|t:.*?|g:.*?';
str = 'a:bob jimg: hi Mom';

a = '';
y = '';
p = '';
t = '';
g = '';

I = strfind(str,':');
if isempty(I)
    g = str;
    %try and extract year
else
   mask = false(1,length(str));
   I = [I length(str) + 2];
   for iIndex = 1:length(I)-1
       curIndex = I(iIndex);
       lastIndexInStr = I(iIndex+1)-2;
       
       switch lower(str(curIndex - 1))
           case 'a'
               a = deblank(str(curIndex+1:lastIndexInStr));
           case 'y'
               y = deblank(str(curIndex+1:lastIndexInStr));
           case 'p'
               p = deblank(str(curIndex+1:lastIndexInStr));
           case 't'
               t = deblank(str(curIndex+1:lastIndexInStr));
           case 'g'
               g = deblank(str(curIndex+1:lastIndexInStr));
           otherwise
               error('Unrecognized request character: %s',str(curIndex - 1))
       end
       
       mask(curIndex - 1:lastIndexInStr) = true;
   end
   %Not sure what to do with mask yet ...
end

temp = regexp(str,pat,'match');