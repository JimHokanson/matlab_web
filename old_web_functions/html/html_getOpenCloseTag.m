function tagBounds = html_getOpenCloseTag(text,type,noRegex)
%html_getOpenCloseTag Computes the tag bounds for a html tag
%
%   tagBounds = html_getOpenCloseTag(text,type, *noRegex)
%
%   NOTE: This function is relatively simple in terms of its processing
%   and does not handle misbehaving tags. Eventually it could be replaced
%   with something more complicated that is more stable.
%
%   INPUTS
%   =======================================================================
%   text : text to process
%   type : string to match, can be regular expression like h\d+ (i.e. h1,
%          h2, h3 etc)
%          NOTE: must be ammenable to querying with < & >, i.e. if you want
%          an OR you must group first (div|span) otherwise <div|span> will
%          cause problems in the search
%
%   noRegex : (default false), if true uses some simpler algorithm which is
%             a bit faster
%
%   OUTPUTS
%   =======================================================================
%   tagBounds (structure array)
%       .tagName   - name of the tag grabbed (useful for regular expression
%                    matches in which it is not clear what the tag will be)
%       .Iopen     - index of the start of the opening tag
%       .IopenEnd  - index of the close of the opening tag
%       .Iclose    - index of the start of the closing tag
%       .IcloseEnd - index of the close of the closing tag
%
%   EXAMPLES
%   =======================================================================
%   text = '<h3>hi Mom</h3> testing <p>hi Dad</p>';
%   type = 'p'
%   tagBounds = html_getOpenCloseTag(text,type);
%   tagBounds =>
%           tagName: 'p'
%             Iopen: 25
%          IopenEnd: 27
%            Iclose: 34
%         IcloseEnd: 37
%
%   JAH TODO:
%   1) Update documentation to reflect new input
%   2) Implement the new input
%   3) Add on single tag support
%
%   A MORE COMPLICATED REQUEST
%   -----------------------------
%   text = '<h3>hi Mom</h3> testing <p>hi Dad</p>';
%   type = '(h\d+|p)';
%   tagBounds = html_getOpenCloseTag(text,type);
%   tagBounds(1) =>
%           tagName: 'h3'
%             Iopen: 1
%          IopenEnd: 4
%            Iclose: 11
%         IcloseEnd: 15
%   tagBounds(2) =>
%           tagName: 'p'
%             Iopen: 25
%          IopenEnd: 27
%            Iclose: 34
%         IcloseEnd: 37

if ~exist('noRegex','var')
    noRegex   = false;
end

if noRegex
    tagBounds = getOpenCloseTagNoRegex(text,type);
else
    tagBounds = getOpenCloseTagRegex(text,type);
end

end

function tagBounds = getOpenCloseTagNoRegex(text,type)
%Find all references matching text then build up open and close ...

textMatch = strfind(lower(text),lower(type));
%textMatch = regexpi(text,type,'start');  %About the same speed

closeTag  = strfind(text,'>');

tagBounds = [];
if isempty(textMatch)
    return
else
    if textMatch(1) == 1
        textMatch(1) = [];
        if isempty(textMatch)
            return
        end
    end
    
    Iopen  = textMatch(text(textMatch-1) == '<') - 1; %The -1
    %puts the opening back on the < character
    
    if textMatch(1) <= 2
        textMatch(1) = [];
        if isempty(textMatch)
            return
        end
    end
    
    Iclose = textMatch(text(textMatch-2) == '<' & text(textMatch-1) == '/') - 2;
    
    if isempty(Iopen)
        return
    end
    
    I1 = computeEdgeIndices(closeTag,Iopen,[Iopen(2:end) length(text)+1]);
    IopenEnd = closeTag(I1);
    
    if isempty(Iclose)
        IcloseEnd = [];  %This might eventually not be an error when 
        %the opening only tags are implemented
    else
        I2 = computeEdgeIndices(closeTag,Iclose,[Iclose(2:end) length(text)+1]);
        IcloseEnd = closeTag(I2);
    end
end

if length(Iopen) ~= length(Iclose)
    %In here check for single tags
    error('Open and closed tags are not properly matched (single tags present like <br>???)')
end

matching_close_index = ...
    matchOpenToClose(zeros(1,length(Iclose)),Iopen,Iclose,1:length(Iopen),1:length(Iclose));

tagBounds = struct(...
    'tagName',  type,...
    'Iopen',    num2cell(Iopen),...
    'IopenEnd', num2cell(IopenEnd),...
    'Iclose',   num2cell(Iclose(matching_close_index)),...
    'IcloseEnd', num2cell(IcloseEnd(matching_close_index)));


end

function openTagEnd = findOpenTagEnd(text,Ifirst,ILast)

openTagEnd = find(isspace(text(Ifirst:ILast)) | text(Ifirst:ILast) == '>',1) + Ifirst - 1;

end


function matching_close_index = ...
    matchOpenToClose(matching_close_index,IopenTemp,IcloseTemp,curOpenI,curCloseI)


%NOTE: This sort takes forever, I could probably do this a lot faster
%by just looping through both of them

openIDmatrix = zeros(1,length(IopenTemp));

curIndex      = 0;
curOpenIndex  = 1;
curCloseIndex = 1;
done = false;
while ~done
    if IopenTemp(curOpenIndex) < IcloseTemp(curCloseIndex)
        curIndex = curIndex + 1;
        openIDmatrix(curIndex) = curOpenI(curOpenIndex);
        if curOpenIndex == length(IopenTemp)
        %Then all of the remaining values are close tags and are flipped
           matching_close_index(openIDmatrix(1:curIndex)) = curCloseI(end:-1:curCloseIndex);  
           done = true;
        else
            curOpenIndex = curOpenIndex + 1;
        end
    else
        if curIndex == 0
            error('Unbalanced opening and closing tags')
        end
        matching_close_index(openIDmatrix(curIndex)) = curCloseI(curCloseIndex);
        curIndex = curIndex - 1;
        %NOTE: We'll never get to this point because
        %we'll always run out of opens first ...
        curCloseIndex = curCloseIndex + 1; 
        
% % %         if curCloseIndex == length(IcloseTemp)
% % %             done = true;
% % %         else
% % %            curCloseIndex = curCloseIndex + 1; 
% % %         end
    end
end

%COMMIT BEFORE DELETING THIS ...
%isOpenTag = false(1,2*length(IopenTemp));
% % % % % [~,Iorig] = sort([IopenTemp IcloseTemp]);
% % % % % 
% % % % % %This now indicates whether or not the sorted tags
% % % % % %are an open or close tag
% % % % % %i.e. if we had something like open close open close
% % % % % %we might have indices of 1 10 for open and 5 and 15 for close
% % % % % %When we sort these we would get 1 3 2 4 and since we know there
% % % % % %were 2 opening tags (based on length) it is easy to tell
% % % % % %that 1 3 2 4 means open close open close
% % % % % %NOTE: We might also get 1 2 3 4 which means open open close close
% % % % % %and indicates that tag 1 is matched with 4
% % % % % isOpenTag(Iorig <= length(IopenTemp)) = true;
% % % % % 
% % % % % 
% % % % % 
% % % % % curIndex      = 0;  %Into openIDmatrix
% % % % % curOpenCount  = 0;
% % % % % curCloseCount = 0;
% % % % % %Actual algorithm
% % % % % %-------------------------------------------
% % % % % %Example:
% % % % % %Let's say we have the following
% % % % % % <div <p  /p   /div   <div  /div> and that we are on div
% % % % % %  1    2   3   4       5    6
% % % % % %  1    2               3        open indices
% % % % % %           1    2           3
% % % % % %
% % % % % %   curOpenI  = [1 3]
% % % % % %   curCloseI = [2 3]
% % % % % %   isOpenTag = [T F T F]
% % % % % %   Every time we see an open tag we push its value onto our stack
% % % % % %   Every time we see a close tag we take the last open off the stack
% % % % % %   and store the index of the close at the correct index of the open
% % % % % %   For this case that means storing close 2 at open 1 and close 3 at
% % % % % %   open 3 so that matching_close_index = [2 0 3], the zero
% % % % % %   changes to a 1 when we move onto <p> tags
% % % % % 
% % % % % %NOTE: The if statement might make things faster ...
% % % % % %This is true if there is no nesting of the tag itself
% % % % % %if ~any(diff(isOpenTag) == 0)
% % % % % if all(isOpenTag(1:2:end))    
% % % % %     matching_close_index(curOpenI) = curCloseI;
% % % % % else
% % % % %     for iTag = 1:length(isOpenTag)
% % % % %         if isOpenTag(iTag)
% % % % %             curOpenCount = curOpenCount + 1;
% % % % %             curIndex     = curIndex + 1;
% % % % %             openIDmatrix(curIndex) = curOpenI(curOpenCount);
% % % % %         else
% % % % %             if curIndex == 0
% % % % %                 error('open and closing tags aren''t balanced')
% % % % %             end
% % % % %             curCloseCount = curCloseCount + 1;
% % % % %             matching_close_index(openIDmatrix(curIndex)) = curCloseI(curCloseCount);
% % % % %             curIndex = curIndex - 1;
% % % % %         end
% % % % %     end
% % % % % end


end







function tagBounds = getOpenCloseTagRegex(text,type)
%REGEX VERSION ------------------------------------------------------------
%NOTE: The regexp approach is a bit slow and could be must faster if
%we were looking for a specific tag like h3 instead of h\d+ or p|div
%which means it is unclear how far after the opening character to go
%<p vs <div
[Iopen,IopenEnd]   = regexpi(text,['<' type '(>| [^>]*?>)'],'start','end');

%QUIT EARLY IF POSSIBLE
%----------------------------------
if isempty(Iopen)
    tagBounds = [];
    return
end

[Iclose,IcloseEnd] = regexpi(text,['</' type '>'],'start','end');

openTagEnd = zeros(1,length(Iopen));
openNames  = cell(1,length(Iopen));

for i_Open = 1:length(Iopen)
    curOpenStart = Iopen(i_Open);
    curOpenEnd   = IopenEnd(i_Open);
    temp = find(isspace(text(curOpenStart:curOpenEnd)),1);
    if isempty(temp)
        openTagEnd(i_Open) = curOpenEnd - 1;
    else
        openTagEnd(i_Open) = temp + curOpenStart - 2;
    end
    %   openTagEnd(i_Open) = find(isspace(text(curOpenStart:curOpenEnd)) | text(curOpenStart:curOpenEnd) == '>',1) + curOpenStart - 1;
    openNames{i_Open}  = text(curOpenStart+1:openTagEnd(i_Open));
end

closeNames = cell(1,length(Iclose));
for i_Open = 1:length(Iclose)
    curCloseStart = Iclose(i_Open);
    curCloseEnd   = IcloseEnd(i_Open);
    closeNames{i_Open}  = text(curCloseStart+2:curCloseEnd-1); %remove closing tag </
end
%END OF REGEX VERSION -----------------------------------------------------

%NEED TO HANDLE SINGLE TAGS HERE
%<br>, adjust open accordingly %JAH TODO

[uOpen,u_open_I]   = unique2(openNames);
[uClose,u_close_I] = unique2(closeNames);

if length(Iopen) ~= length(Iclose)
    
    %In here check for single tags
    
    error('Open and closed tags are not properly matched (single tags present like <br>???)')
end

if ~isequal(uOpen,uClose)
    error('The unique tag names for opening and closing tags should be equal')
end

if ~isequal(cellfun('length',u_open_I),cellfun('length',u_close_I))
    error('The # of tags for a specific tag are not equal')
end

matching_close_index = zeros(1,length(Iclose));

%LOOP OVER UNIQUE TAGS FOUND
%-------------------------------------------
for iUniqueTag = 1:length(uOpen)
    
    %Initialization procedure
    %------------------------------------------
    curOpenI   = u_open_I{iUniqueTag};
    curCloseI  = u_close_I{iUniqueTag};
    IopenTemp  = Iopen(u_open_I{iUniqueTag});
    IcloseTemp = Iclose(u_close_I{iUniqueTag});
    
    matching_close_index = ...
    matchOpenToClose(matching_close_index,IopenTemp,IcloseTemp,curOpenI,curCloseI);
end
%-----------------------------------------

%change to struct array
tagBounds = struct(...
    'tagName',  openNames,...
    'Iopen',    num2cell(Iopen),...
    'IopenEnd', num2cell(IopenEnd),...
    'Iclose',   num2cell(Iclose(matching_close_index)),...
    'IcloseEnd', num2cell(IcloseEnd(matching_close_index)));

end