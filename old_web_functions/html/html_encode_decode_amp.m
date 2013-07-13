function str = html_encode_decode_amp(option,str,varargin)
%html_encode_decode_amp  HTML encodes & decodes
%
%   str = html_encode_decode_amp(option,str,varargin)
%
%   INPUTS
%   =====================================
%   str   : input string to process
%   option:
%       - 'encode' -> convert symbols to ampersands
%       - 'decode' -> remove ampersands
%
%   EXAMPLES
%   ======================================
%   str = html_encode_decode_amp('decode','This is cheap &amp; easy');
%   str => This is cheap & easy
 
switch option(1)
    case {'d' 'D'}
        %I think this could speed things up significantly ...
        %Presumably the function below is doing that but the 
        %in and out of Java is bad, perhaps pure Matlab would be quicker
        %...
        if isempty(strfind(str,'&'))
            %Do nothing
        else
            str = char(org.apache.commons.lang.StringEscapeUtils.unescapeHtml(str));
        end
    case {'e' 'E'}
        str = char(org.apache.commons.lang.StringEscapeUtils.escapeHtml(str)); 
    otherwise
        error('invalid option, check usage')
end

