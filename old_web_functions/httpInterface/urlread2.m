function [output,extras] = urlread2(urlChar,method,body,headersIn,varargin)
%urlread2  Makes HTTP requests and processes response
%
%   [output,extras] = urlread2(urlChar, *method, *body, *headersIn, varargin)
%
%   * indicates optional inputs that must be entered in place
%
%   UNDOCUMENTED MATLAB VERSION
%
%   EXAMPLE CALLING FORMS
%   ... = urlread2(urlChar)
%   ... = urlread2(urlChar,'GET','',[],prop1,value1,prop2,value2,etc)
%   ... = urlread2(urlChar,'POST',body,headers)
%   
%   FEATURES
%   =======================================================================
%   1) Allows specification of any HTTP method
%   2) Allows specification of any header. Very little is hard-coded
%      in for header handling.
%   3) Returns response status and headers
%   4) Should handle unicode properly ...
%
%   OUTPUTS
%   =======================================================================
%   output : body of the response, either text or binary depending upon
%            CAST_OUTPUT property
%   extras : (structure)
%       .allHeaders  - stucture, fields have cellstr values, HTTP headers may 
%           may be repeated but will have a single field entry, with each
%           repeat's value another being another entry in the cellstr, for
%           example:
%               .Set_Cookie = {'first_value' 'second_value'}
%       .firstHeaders - (structure), variable fields, contains the first
%                      string entry for each field in allHeaders, this
%                      structure can be used to avoid dereferencing a cell
%                      for fields you expect not to be repeated ...
%                   EXAMPLE:
%                   .Response       : 'HTTP/1.1 200 OK'}
%                   .Server         : 'nginx'
%                   .Date           : 'Tue, 29 Nov 2011 02:23:16 GMT'
%                   .Content_Type   : 'text/html; charset=UTF-8'
%                   .Content_Length : '109155'
%                   .Connection     : 'keep-alive'
%                   .Vary           : 'Accept-Encoding, User-Agent'
%                   .Cache_Control  : 'max-age=60, private'
%                   .Set_Cookie     : 'first_value'
%       .status     - (structure)
%               .value  : numeric value of status, ex. 200
%               .msg    : message that goes along with status, ex. 'OK'
%       .url        - eventual url that led to output, this can change from
%                     the input with redirects, see FOLLOW_REDIRECTS
%       .isGood     - (logical) I believe this is an indicator of the presence of 400
%                      or 500 status codes (see status.value) but more
%                      testing is needed. In other words, true if status.value < 400.
%                      In code, set true if the response was obtainable without 
%                      resorting to checking the error stream.
%
%   INPUTS
%   =======================================================================
%   http_struct : 
%
%
%   urlChar   : The full url, must include scheme (http, https)
%   method    : examples: 'GET' 'POST' etc
%   body      : (vector)(char, uint8 or int8) body to write, generally used 
%               with POST or PUT, use of uint8 or int8 ensures that the 
%               body input is not manipulated before sending, char is sent
%               via unicode2native function with ENCODING input (see below)
%   headersIn : (structure array), use empty [] or '' if no headers are needed
%                   but varargin property/value pairs are, multiple headers
%                   may be passed in as a structure array
%       .name    - (string), name of the header, a name property is used
%                   instead of a field because the name must match a valid
%                   header
%       .value   - (string), value to use
%
%   OPTIONAL INPUTS (varargin, property/value pairs)
%   =======================================================================
%   CAST_OUTPUT      : (default true) output is uint8, useful if the body
%                       of the response is not text
%   ENCODING         : (default ''), ENCODING input to function unicode2native
%   FOLLOW_REDIRECTS : (default true), if false 3xx status codes will
%                       be returned and need to be handled by the user,
%                       note this does not handle javascript or meta tag
%                       redirects, just server based ones
%   READ_TIMEOUT     : (default 10000), 0 means no timeout, value is in
%                       milliseconds
%
%   EXAMPLES
%   =======================================================================
%   GET:
%   --------------------------------------------
%   url    = 'http://www.mathworks.com/matlabcentral/fileexchange/';
%   query  = 'urlread2';
%   params = {'term' query};
%   queryString = http_paramsToString(params,1);
%   url = [url '?' queryString];
%   [output,extras] = urlread2(url);
%
%   POST:
%   --------------------------------------------
%   url    = 'http://posttestserver.com/post.php';
%   params = {'testChars' char([2500 30000]) 'new code' '?'};
%   [paramString,header] = http_paramsToString(params,1);
%   [output,extras] = urlread2(url,'POST',paramString,header);
%
%   From behind a firewall, use the Preferences to set your proxy server.
%
%   See Also:
%       http_paramsToString
%       unicode2native
%       native2unicode
%   
%   Subfunctions:
%   fixHeaderCasing - small subfunction to fix case errors encountered in real
%       world, requires updating when casing doesn't match expected form, like
%       if someone sent the header content-Encoding instead of
%       Content-Encoding
%
%   Based on original urlread code by Matthew J. Simoneau
%
%   VERSION = 1.2

if isstruct(urlChar)
	[urlChar,method,body,headersIn] = http_expandRequestStruct(urlChar);
end

in.CAST_OUTPUT      = true;
in.FOLLOW_REDIRECTS = true;
in.READ_TIMEOUT     = 10000; %If you need longer, you should know and set it as such ...
in.ENCODING         = '';
in.USE_COOKIES      = true;
in.DEPTH            = 0; %Don't set this ..., for use with redirects
in = processVarargin(in,varargin);

MAX_FOLLOWS = 5;

if ~exist('method','var') || isempty(method),   method = 'GET'; end
if ~exist('body','var'),                        body   = '';    end
if ~exist('headersIn','var'),                   headersIn = []; end

assert(usejava('jvm'),'Function requires Java')

import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;
com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings %Proxy settings need to be set

%Create a urlConnection.
%-----------------------------------
urlConnection = getURLConnection(urlChar);

if in.USE_COOKIES
   cookies.enable;
else
   cookies.disable;
end

%For HTTP uses sun.net.www.protocol.http.HttpURLConnection
%Might use ice.net.HttpURLConnection but this has more overhead

%SETTING PROPERTIES
%-------------------------------------------------------
 
if in.USE_COOKIES
   %With cookies we manually follow redirects so as to 
   %support cookies on the redirected site, otherwise the automatic
   %redirect following in the java class will not provide cookies to the
   %new site
   try_follow_redirects = in.FOLLOW_REDIRECTS;
   in.FOLLOW_REDIRECTS  = false;
   [header,cookie_h,cookie_file_path] = http_loadCookie(urlConnection.getURL);
   headersIn = [headersIn header];
else
   %Rely on input
   %Java will redirect or not, no need to do manually
   try_follow_redirects = false;   
end



urlConnection.setRequestMethod(upper(method));
urlConnection.setFollowRedirects(in.FOLLOW_REDIRECTS);
urlConnection.setReadTimeout(in.READ_TIMEOUT);

for iHeader = 1:length(headersIn)
    curHeader = headersIn(iHeader);
    urlConnection.setRequestProperty(curHeader.name,curHeader.value);
end

if ~isempty(body)
    %Ensure vector?
    if size(body,1) > 1
        if size(body,2) > 1
            error('Input parameter to function: body, must be a vector')
        else
            body = body';
        end
    end

    if ischar(body)
        %NOTE: '' defaults to Matlab's default encoding scheme 
        body = unicode2native(body,in.ENCODING);
    elseif ~(strcmp(class(body),'uint8') || strcmp(class(body),'int8'))
        error('Function input: body, should be of class char, uint8, or int8, detected: %s',class(body))
    end
    
    urlConnection.setRequestProperty('Content-Length',int2str(length(body)));
    urlConnection.setDoOutput(true);
    outputStream = urlConnection.getOutputStream;
    outputStream.write(body);
    outputStream.close;
else
    urlConnection.setRequestProperty('Content-Length','0');
end

%==========================================================================
%                   Read the data from the connection.
%==========================================================================
%This should be done first because it tells us if things are ok or not
%NOTE: If there is an error, functions below using urlConnection, notably
%getResponseCode, will fail as well
try
    inputStream = urlConnection.getInputStream;
    isGood = true;
catch ME
    isGood = false; 
%NOTE: HTTP error codes will throw an error here, we'll allow those for now
%We might also get another error in which case the inputStream will be
%undefined, those we will throw here
    inputStream = urlConnection.getErrorStream;
    
    if isempty(inputStream)
        msg = ME.message;
        I = strfind(msg,char([13 10 9])); %see example by setting timeout to 1
        %Should remove the barf of the stack, at ... at ... at ... etc
        %Likely that this could be improved ... (generate link with full msg)
        if ~isempty(I)
            msg = msg(1:I(1)-1);
        end
        fprintf(2,'Response stream is undefined\n below is a Java Error dump (truncated):\n');
        error(msg)
    end
end


%POPULATING HEADERS
%--------------------------------------------------------------------------
allHeaders = struct;
allHeaders.Response = {char(urlConnection.getHeaderField(0))};

done = false;
headerIndex = 0;

%NOTE:  m = urlConnection.getHeaderFields; %yields size

while ~done
    headerIndex = headerIndex + 1;
    headerValue = char(urlConnection.getHeaderField(headerIndex));
    if ~isempty(headerValue)
        headerName = char(urlConnection.getHeaderFieldKey(headerIndex));
        headerName = fixHeaderCasing(headerName); %NOT YET FINISHED
        
        %Important, for name safety all hyphens are replace with underscores
        headerName(headerName == '-') = '_';
        if isfield(allHeaders,headerName)
            allHeaders.(headerName) = [allHeaders.(headerName) headerValue];
        else
            allHeaders.(headerName) = {headerValue}; 
        end
    else
        done = true;
    end
end

firstHeaders = struct;
fn = fieldnames(allHeaders);
for iHeader = 1:length(fn)
   curField = fn{iHeader};
   firstHeaders.(curField) = allHeaders.(curField){1};
end

status = struct(...
    'value',    urlConnection.getResponseCode(),...
    'msg',      char(urlConnection.getResponseMessage));


%COOKIE HANDLING
%--------------------------------------------------------------------------
if isGood && in.USE_COOKIES
    http_saveCookie(allHeaders,urlConnection.getURL,cookie_h,cookie_file_path)
end



%REDIRECT HANDLING 
%-------------------------------------------------------------
%below no longer applies, back to implementing myself
%http://stackoverflow.com/questions/1884230/java-doesnt-follow-redirect-in-urlconnection

if try_follow_redirects && floor(status.value/100) == 3
    
    %Need to set this back to true :/
    in.FOLLOW_REDIRECTS  = false;
    
    in.DEPTH = in.DEPTH + 1;
    if in.DEPTH > MAX_FOLLOWS
        error('Maximum # of follows exceeded')
    end
    switch status.value
        case 302
            %use location
            newURL = allHeaders.Location{1};
            newURL = url_getAbsoluteUrl(urlChar,newURL);
            [output,extras] = urlread2(newURL,'GET','','',in);
            return
        otherwise
            error('Redirect status ot handled')
    end
end

%PROCESSING OF OUTPUT
%----------------------------------------------------------
% byteArrayOutputStream = java.io.ByteArrayOutputStream;
% % This StreamCopier is unsupported and may change at any time. OH GREAT :/
% isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
% isc.copyStream(inputStream,byteArrayOutputStream);
% inputStream.close;
% byteArrayOutputStream.close; 

% u = urlReader;
% wtf2 = u.inputStreamToString(inputStream);



% byteArrayOutputStream = java.io.ByteArrayOutputStream;
% org.apache.commons.io.IOUtils.copy(inputStream,byteArrayOutputStream);
% 
% byteArrayOutput = byteArrayOutputStream.toByteArray';

%byteArrayOutput = org.apache.commons.io.IOUtils.toByteArray(urlConnection)';
%huh = org.apache.commons.io.IOUtils.toString(inputStream);

%byteArrayOutput = org.apache.commons.io.IOUtils.toByteArray(inputStream,int32(10))';

%byteArrayOutput = org.apache.commons.io.IOUtils.toByteArray(inputStream,int32(118198))';
byteArrayOutput = org.apache.commons.io.IOUtils.toByteArray(inputStream)';
inputStream.close;


%NOTE: With html 5 you can now specify the character set as a meta tag
%http://www.w3schools.com/tags/att_meta_charset.asp
%NOTE: urlread assumes utf-8 which might normally be a good assumption

if in.CAST_OUTPUT
    charset = '';
    
    %Extraction of character set from Content-Type header if possible
    if isfield(firstHeaders,'Content_Type')
        text = firstHeaders.Content_Type;
        %Always open to regexp improvements
        charset = regexp(text,'(?<=charset=)[^\s]*','match','once');
    end

    if ~isempty(charset)
        output = native2unicode(typecast(byteArrayOutput,'uint8'),charset);
    else
        output = char(typecast(byteArrayOutput,'uint8'));
    end
else
    %uint8 is more useful for later charecter conversions
    %uint8 or int8 is somewhat arbitary at this point
    output = typecast(byteArrayOutput,'uint8');
end

extras              = struct;
extras.allHeaders   = allHeaders;
extras.firstHeaders = firstHeaders;
extras.status       = status;
extras.url_obj      = urlConnection.getURL;
extras.url          = char(extras.url_obj);
extras.isGood       = isGood;
extras.input_options = in;


end

function headerNameOut = fixHeaderCasing(headerName)
%fixHeaderCasing Forces standard casing of headers
%
%   headerNameOut = fixHeaderCasing(headerName)
%   
%   This is important for field access in a structure which
%   is case sensitive
%
%   Not yet finished. 
%   I've been adding to this function as problems come along
    
    switch lower(headerName)
        case 'location'
            headerNameOut = 'Location';
        case 'content_type'
            headerNameOut = 'Content_Type';
        otherwise
            headerNameOut = headerName;
    end
end

%==========================================================================
%==========================================================================
%==========================================================================

function urlConnection = getURLConnection(urlChar)
%getURLConnection
%
%   urlConnection = getURLConnection(urlChar)

% Determine the protocol (before the ":").
protocol = urlChar(1:find(urlChar==':',1)-1);


% Try to use the native handler, not the ice.* classes.
try
    switch protocol
        case 'http'
            %http://www.docjar.com/docs/api/sun/net/www/protocol/http/HttpURLConnection.html
            handler = sun.net.www.protocol.http.Handler;
        case 'https'
            handler = sun.net.www.protocol.https.Handler;
    end
catch ME
    handler = [];
end

% Create the URL object.
try
    if isempty(handler)
        url = java.net.URL(urlChar);
    else
        url = java.net.URL([],urlChar,handler);
    end
catch ME
    error('Failure to parse URL or protocol not supported for:\nURL: %s',urlChar);
end

% Get the proxy information using MathWorks facilities for unified proxy
% preference settings.
mwtcp = com.mathworks.net.transport.MWTransportClientPropertiesFactory.create();
proxy = mwtcp.getProxy();

% Open a connection to the URL.
if isempty(proxy)
    urlConnection = url.openConnection;
else
    urlConnection = url.openConnection(proxy);
end


end
