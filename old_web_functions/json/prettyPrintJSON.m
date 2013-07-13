function strOut = prettyPrintJSON(strIn)
%prettyPrintJSON Converts JSON to clean format for viewing
%
%   strOut = prettyPrintJSON(strIn)

%For parsing the json
%----------------------------------------------------------------------
pos = 1;
len = length(strIn);
%delimiters and escape characters are identified beforehand to improve speed
esc = regexp(strIn, '["\\]');
index_esc = 1;
len_esc = length(esc);


%For marking up the text
%----------------------------------------------------------------------
GROW_SIZE = 10;
INIT_SIZE = 10;
returnIndices = zeros(1,INIT_SIZE);
returnDepths  = zeros(1,INIT_SIZE);
curDepth = 0;
curIndex = 0;

if pos <= len
    switch(next_char)
        case '{'
            parse_object;
        case '['
            parse_array;
        otherwise
            error_pos('Outer level structure must be an object or an array');
    end
end

insertionStrings = arrayfun(@(x) [char(10) char(32*ones(1,x*4))],...
    returnDepths(1:curIndex),'UniformOutput',false);

strOut = insertCharsIntoArray(strIn,insertionStrings,returnIndices(1:curIndex)-1);

    function openObjectArray
        %addReturn
        curDepth = curDepth + 1;
    end

    function addReturn(goBack)
        if nargin == 0
            goBack = false;
        end
        curIndex = curIndex + 1;
        if curIndex > length(returnIndices)
            %resize
            returnIndices = [returnIndices zeros(1,GROW_SIZE)];
            returnDepths  = [returnDepths  zeros(1,GROW_SIZE)];
        end
        if goBack
            returnIndices(curIndex) = pos - 1;
        else
            returnIndices(curIndex) = pos;
        end
        
        returnDepths(curIndex)  = curDepth;
    end

    function closeObjectArray
        curDepth = curDepth - 1;
        addReturn(true)
    end

    function parse_object
        
        parse_char('{');
        openObjectArray
        %object = [];
        if next_char ~= '}'
            while 1
                addReturn
                str = parse_string;
                if isempty(str)
                    error_pos('Name of value at position %d cannot be empty');
                end
                parse_char(':');
                parse_value;
                if next_char == '}'
                    break;
                end
                parse_char(',');
            end
        end
        parse_char('}');
        closeObjectArray
    end

    function parse_array
        parse_char('[');
        openObjectArray
        if next_char ~= ']'
            while 1
                addReturn
                parse_value;
                if next_char == ']'
                    break;
                end
                parse_char(',');
            end
        end
        parse_char(']');
        closeObjectArray
    end

    function parse_char(c)
        skip_whitespace;
        if pos > len || strIn(pos) ~= c
            error_pos(sprintf('Expected %c at position %%d', c));
        else
            pos = pos + 1;
            skip_whitespace;
        end
    end

    function c = next_char
        skip_whitespace;
        if pos > len
            c = [];
        else
            c = strIn(pos);
        end
    end

    function skip_whitespace
        while pos <= len && isspace(strIn(pos))
            pos = pos + 1;
        end
    end

    function str = parse_string
        if strIn(pos) ~= '"'
            error_pos('strIn starting with " expected at position %d');
        else
            pos = pos + 1;
        end
        str = '';
        while pos <= len
            while index_esc <= len_esc && esc(index_esc) < pos
                index_esc = index_esc + 1;
            end
            if index_esc > len_esc
                str = [str strIn(pos:end)];
                pos = len + 1;
                break;
            else
                str = [str strIn(pos:esc(index_esc)-1)];
                pos = esc(index_esc);
            end
            switch strIn(pos)
                case '"'
                    pos = pos + 1;
                    return;
                case '\'
                    if pos+1 > len
                        error_pos('End of file reached right after escape character');
                    end
                    pos = pos + 1;
                    switch strIn(pos)
                        case {'"' '\' '/'}
                            str(end+1) = strIn(pos);
                            pos = pos + 1;
                        case {'b' 'f' 'n' 'r' 't'}
                            str(end+1) = sprintf(['\' strIn(pos)]);
                            pos = pos + 1;
                        case 'u'
                            if pos+4 > len
                                error_pos('End of file reached in escaped unicode character');
                            end
                            str(end+1:end+6) = strIn(pos-1:pos+4);
                            pos = pos + 5;
                    end
                otherwise % should never happen
                    str(end+1) = strIn(pos);
                    pos = pos + 1;
            end
        end
        error_pos('End of file while expecting end of strIn');
    end

    function num = parse_number
        [num, one, err, delta] = sscanf(strIn(pos:min(len,pos+20)), '%f', 1); %#ok<*ASGLU> % TODO : compare with json(pos:end)
        if ~isempty(err)
            error_pos('Error reading number at position %d');
        end
        pos = pos + delta-1;
    end

    function parse_value
        switch(strIn(pos))
            case '"'
                parse_string;
                return;
            case '['
                parse_array;
                return;
            case '{'
                parse_object;
                return;
            case {'-','0','1','2','3','4','5','6','7','8','9'}
                parse_number;
                return;
            case 't'
                if pos+3 <= len && strcmpi(strIn(pos:pos+3), 'true')
                    pos = pos + 4;
                    return;
                end
            case 'f'
                if pos+4 <= len && strcmpi(strIn(pos:pos+4), 'false')
                    pos = pos + 5;
                    return;
                end
            case 'n'
                if pos+3 <= len && strcmpi(strIn(pos:pos+3), 'null')
                    pos = pos + 4;
                    return;
                end
        end
        error_pos('Value expected at position %d');
    end

    function error_pos(msg)
        poss = max(min([pos-15 pos-1 pos pos+20],len),1);
        if poss(3) == poss(2)
            poss(3:4) = poss(2)+[0 -1];         % display nothing after
        end
        msg = [sprintf(msg, pos) ' : ... ' strIn(poss(1):poss(2)) '<error>' strIn(poss(3):poss(4)) ' ... '];
        ME = MException('JSONparser:invalidFormat', msg);
        throw(ME);
    end

end