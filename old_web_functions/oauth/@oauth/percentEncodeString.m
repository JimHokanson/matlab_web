function outputStr = percentEncodeString(inputStr)
%percentEncodeString  Percent encodes a string, ex. '+' to '%2B'
%
%   output_string = percentEncodeString(input_string) 
%
%   Takes an input string and percent encodes it based on Section 3.6 of
%   the Oauth Protocol
%
%   NOTE: The inputs should already be utf-8 encoded for this method to be
%   valid. 
%
%   http://tools.ietf.org/html/rfc5849#section-3.6

%------------------------------------------------------------------
%characters to keep are _-.~ & alpha characters
charsGood = ismember(upper(inputStr),'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-.~');

%preallocation:
%1 bad character equals 3 escape characters (% and 2 hex chars)
%adds on an additional 2 characters to the length
outputStr = char(ones(1,length(inputStr)+2*length(find(~charsGood))));

curIndex = 0;
for iChar = 1:length(charsGood)
    curIndex = curIndex + 1;
    if charsGood(iChar)
        outputStr(curIndex) = inputStr(iChar);
    else
        outputStr(curIndex) = '%';
        %If this fails it is because the text hasn't been utf-8 encoded
        %In general I assume it has, but I would need to build in special
        %support if it hasn't ...
        temp = double(inputStr(iChar));
        if temp > 255
            error(['Text needs to be UTF-8 encoded prior to percent encoding a string:\n' ...
            'offending char: %s\nin string: %s'],inputStr(iChar),inputStr)
            %Weird, this shows up wrong if I have a dbstop if error enabled ...
        end
            
        outputStr(curIndex+1:curIndex+2) = dec2hex(temp);
        %NOTE:dec2hex returns characters in uppercase
        curIndex = curIndex + 2;
    end
end

%==========================================================================
%PERCENT ENCODING - SECTION 3.6
%==========================================================================
%  Existing percent-encoding methods do not guarantee a consistent
%    construction of the signature base string.  The following percent-
%    encoding method is not defined to replace the existing encoding
%    methods defined by [RFC3986] and [W3C.REC-html40-19980424].  It is
%    used only in the construction of the signature base string and the
%    "Authorization" header field.
% 
%    This specification defines the following method for percent-encoding
%    strings:
% 
%    1.  Text values are first encoded as UTF-8 octets per [RFC3629] if
%        they are not already.  This does not include binary values that
%        are not intended for human consumption.
% 
%    2.  The values are then escaped using the [RFC3986] percent-encoding
%        (%XX) mechanism as follows:
% 
%        *  Characters in the unreserved character set as defined by
%           [RFC3986], Section 2.3 (ALPHA, DIGIT, "-", ".", "_", "~") MUST
%           NOT be encoded.
% 
%        *  All other characters MUST be encoded.
% 
%        *  The two hexadecimal characters used to represent encoded
%           characters MUST be uppercase.
% 
%    This method is different from the encoding scheme used by the
%    "application/x-www-form-urlencoded" content-type (for example, it
%    encodes space characters as "%20" and not using the "+" character).
%    It MAY be different from the percent-encoding functions provided by
%    web-development frameworks (e.g., encode different characters, use
%    lowercase hexadecimal characters).
