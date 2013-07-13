function output = url_parseURL(url,previousURL)
%url_parseURL Parses a http url into constituent parts
%
%   This should work for all urls but was written specifically for http/s
%
%   USAGE FORMS
%   =======================================================================
%   output = url_parseURL(url)
%
%   output = url_parseURL(url,previousURL) for when url may be relative. If
%   not relative, then the url itself is parsed without reference to the
%   previousURL
%
%   STANDARDS
%   ==================================================================
%   http://www.ietf.org/rfc/rfc3986.txt - urls, partially complete
%
%   OUTPUTS
%   =======================================================================
%   output
%       .scheme  : http, https, ftp, etc
%       .domain  : 
%       .port    : port # if specified
%       .urlRoot : all the stuff before the first "/"
%       .paths   : paths after urlRoot
%       .fullPath : all of the paths together
%       .query   : text that is in query 
%       .id      : text that follows #
%       
%   EXAMPLE OUTPUTS
%   =======================================================================
%   url =
%   'http://en.wikipedia.org/wiki/List_of_most_popular_dog_breeds#Most_popular_breeds_pre-2006';
%   output =>
%       scheme: 'http'
%       domain: 'en.wikipedia.org'
%         port: []
%      urlRoot: 'http://en.wikipedia.org'
%        paths: {'wiki'  'List_of_most_popular_dog_breeds'}
%     fullPath: '/wiki/List_of_most_popular_dog_breeds'
%        query: []
%           id: 'Most_popular_breeds_pre-2006'
%     java_obj:
%
%   url = 'http://pittcat.pitt.edu/cgi-bin/Pwebrecon.cgi?DB=local&PAGE=hbSearch';
%   output =>
%       scheme: 'http'
%       domain: 'pittcat.pitt.edu'
%         port: []
%      urlRoot: 'http://pittcat.pitt.edu'
%        paths: {'cgi-bin'  'Pwebrecon.cgi'}
%     fullPath: '/cgi-bin/Pwebrecon.cgi'
%        query: 'DB=local&PAGE=hbSearch'
%           id: []
%
%   NOTE: Although not part of the path, fullPath contains a leading
%   '/' for ease of use when concatenating with the domain
%
%   See Also:
%   url_getAbsoluteUrl
%   url_getURLfromParsed




%EXAMPLE URLS
%==========================================================================
%scheme://domain:port/path?query_string#fragment_id
%
%scheme://username:password@domain:port/path?query_string#fragment_id
%for testing:
%http://username:password@domain:80/path?query_string#fragment_id


%METHODS
%================================================
%java.net.URL:
%     'URL'      
%     'equals'   
%     'getAuthority'
%     'getClass' 
%     'getContent'
%     'getDefaultPort'
%     'getFile'  
%     'getHost'  
%     'getPath'  
%     'getPort'  
%     'getProtocol'
%     'getQuery' 
%     'getRef'   
%     'getUserInfo'
%     'hashCode' 
%     'notify'   
%     'notifyAll'
%     'openConnection'
%     'openStream'
%     'sameFile' 
%     [1x26 char]
%     'toExternalForm'
%     'toString' 
%     'toURI'    
%     'wait'

if ~exist('previousURL','var')
    previousURL = []; %NULL
elseif ischar(previousURL)
    previousURL = java.net.URL(previousURL);
elseif isstruct(previousURL)
    previousURL = previousURL.java_obj;
end

%RELATIVE URL HANDLING - CASES
%---------------------------------------------
%1) struct & no previous - do nothing
%2) struct & previous    - SHOULDN'T HAPPEN?
%3) obj    & no previous - just parse output
%4) obj    & previous    - SHOULDN'T HAPPEN?
%5) obj    & no previous 
%6) char   & previous    - call function

if isstruct(url)
    if ~isempty(previousURL)
        error('Unexpected case')
    else
        return
    end
elseif isjava(url)
    if ~isempty(previousURL)
        error('Unexpected case')
    else
        obj = url;
    end
else
    if ~isempty(previousURL) 
       obj = java.net.URL(previousURL,url);
    else
       obj = java.net.URL(url); 
    end
end


output.scheme = char(getProtocol(obj));
output.domain = char(getHost(obj));
output.port   = getPort(obj);
if output.port == -1
    output.port = [];
end


%Everything before the paths
authority       = char(getAuthority(obj));
%returns: username:password@domain:port
output.urlRoot  = [output.scheme '://' authority];

%Removed username and password
%To restore these would be the authority minus the host

output.fullPath = char(getPath(obj));

if isempty(output.fullPath)
    output.fullPath = '/';
    output.paths    = {};
elseif length(output.fullPath) == 1
    %Should be just '/'
    output.paths = {};
elseif output.fullPath(end) == '/'
    %NOTE: We don't want an extra paths entry on the end
    %ex. /path1/path2/
    output.paths = regexp(output.fullPath(2:end-1),'/','split');
else
    %ex. /path1/path2
    output.paths = regexp(output.fullPath(2:end),'/','split');
end

output.query    = char(getQuery(obj));
output.id       = char(getRef(obj));
output.java_obj = obj;
output.raw_url  = url;

