function att_struct = html_getAttributesTag(str,att_struct_in,idx)
%getAttributesTag  Returns structure with all attributes as fields
%
%   att_struct = getAttributesTag(str)
%
%   INPUTS
%   =======================================================================
%   str : opening tag, see example
%
%   OUTPUTS
%   =======================================================================
%   att_struct : (structure)
%       .(?)  - field names are based on the property names
%               IMPORTANT:
%               1) all hyphens are replaced with underscores
%               2) all names are lowercase
%               3) isolated properties (without values) are given their
%                  property name as the value
%
%   EXAMPLE
%   =======================================================================
%   str = '<input maxlength="256" size="40" name="q" value="">';
%   att_struct = html_getAttributesTag(str)
%   att_struct =>
%     maxlength: '256'
%          size: '40'
%          name: 'q'
%         value: ''
%
%   str = '<input type="checkbox" name="vehicle" value="Bike" />';
%
%   str = '<td align=right nowrap width=120>';
%
%   str = <input id=as_sdt1 type=radio name=as_sdt value="1,39" checked>;

%IMPROVEMENTS:
%This function does not yet handle spaces on either side of the equals sign
%i.e. prop = value or prop = "value" is not currently supported ...

if exist('att_struct_in','var')
    att_struct = att_struct_in;
else
    att_struct = struct;
    idx = 1;
end

if ~ischar(str)
   a = str.attributes;
   a_i = a.iterator;
   n = a.size;
   for iA = 1:n
      temp_att = a_i.next;
      key   = temp_att.getKey;
      value = temp_att.getValue;
      if isempty(value)
          %Like for selected and checked
          %NOTE: Some times this is for the key "value"
          %so it needs to be a string, at least in that case ...
          value = 'true';
      end
      key(key == '-') = '_';
      att_struct(idx).(key) = value;
   end
   return
end


spMask = isspace(str);
EQ = find(str == '=' | spMask);

if isempty(EQ)
    att_struct = [];
    return
end

SP = find(spMask);
DQ = strfind(str,'"');
SQ = strfind(str,'''');

curPos = 0;
while 1
    
    %ADVANCE TO CHAR
    %----------------------------------------------------------------------
    I = find(SP >= curPos,1);
    if length(SP) ~= I
        while 1
            %In other words, is there a space next to us
            if length(SP) ~= I && SP(I+1) == SP(I)+1
                I = I + 1;
            else
                break
            end
        end
    end
    curPos = SP(I);
    
    propStart = curPos+1;
    
    %ADVANCE TO:
    %   - next equals sign
    %   - next space
    %   - end of string and terminate
    %----------------------------------------------------------------------
    curPos = EQ(find(EQ > curPos,1));
    if isempty(curPos)
        propName = str(propStart:length(str)-1);
        if ~isempty(propName)
            if propName(end) == '/'
                propName(end) = [];
            end
            if ~isempty(propName)
                propName(propName == '-') = '_';
                att_struct.(lower(propName)) = propName;
            end
        end
        break
    elseif str(curPos) ~= '='
        propName = str(propStart:curPos-1);
        propName(propName == '-') = '_';
        att_struct.(lower(propName)) = propName;
    end
    
    propEnd = curPos-1;
    
    %Currently curPos points to equals sign
    switch str(curPos+1);
        case '"'
            %prop="value"
            valStart = curPos + 2;
            curPos   = DQ(find(DQ >= curPos + 2,1));
        case ''''
            %prop='value'
            valStart = curPos + 2;
            curPos   = SQ(find(SQ >= curPos + 2,1));
        otherwise
            %we are looking for 'prop=value ' (space at end)
            valStart = curPos+1;
            if SP(end) < valStart
                curPos = length(str);
            else
                curPos = SP(find(SP >= valStart,1));
            end
    end

    propName = lower(str(propStart:propEnd));
    propName(propName == '-') = '_';
    if valStart == curPos
        att_struct.(propName) = '';
    else
        att_struct.(propName) = html_encode_decode_amp('decode',str(valStart:curPos - 1));
    end

    if SP(end) < curPos
        break
    end
    
end

end

