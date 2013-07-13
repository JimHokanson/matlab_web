function [h,cookie_file] = http_getCookiesFromFile(RESET)
%http_getCookiesFromFile Loads cookies from file
%
%   FORMS
%   ===========================================================
%   1) [h,cookie_file] = http_getCookiesFromFile(*RESET)
%
%   2) N = http_getCookiesFromFile('n')
%
%   Handles loading of cookies from file or initialization of a new structure
%
%   INPUTS
%   =======================================================================
%   RESET : (default false), if true, resets all cookies
%   
%   OUTPUTS :
%   =======================================================================
%   N : The initialization size of this structure
%
%   h : (structure), cookie structure
%       .cNames     - (cellstr) name of the variable
%       .cValues    - (cellstr) value of the variable
%       These next two are stored backwards for comparison purposes
%       .cDomain    - (cellstr) domain to which the cookie belongs
%       .cPath      - (cellstr) path in which to apply the cookie
%       .cSecure    - (logical array) use only if secure
%       .cHOnly     - (logical array) use only with http
%       .cExpires   - (num. array) expiration date (Matlab time)
%       .lastAccess - (num. array) last access time " " "
%       .created    - (num. array) time created " " " 
%       .curIndex   - last index that is used
%
%   NOTE: Relies on user contants, getUserConstants
%   C.WEB_DATA_ROOT
%
%   Alternatively, if getUserConstants is not available, a file
%   matlabWebCookies.mat is stored in the userpath
%
%   See Also:
%       http_trimCookies
%       getUserConstants 
%       userpath

N = 200;

if ~exist('RESET','var')
    RESET = false;
elseif ischar(RESET)
    h = N;
    cookie_file = [];
    return
end

if ~exist('getUserConstants','file')
    allUserPaths = regexp(userpath,pathsep,'split');
    cookie_file  = fullfile(allUserPaths{1},'matlabWebCookies.mat');    
else
    cookie_file  = fullfile(getUserConstants('-WEB_DATA_ROOT'),'cookie.mat');
end

if ~exist(cookie_file,'file') || RESET
    h = struct;
    h.cNames     = cell(1,N);
    h.cValues    = cell(1,N);
    h.cDomain    = cell(1,N);
    h.cPath      = cell(1,N);
    h.cSecure    = false(1,N);
    h.cHOnly     = false(1,N);
    h.cExpires   = zeros(1,N);
    h.lastAccess = zeros(1,N);
    h.created    = zeros(1,N);
    h.curIndex   = 0;
else
    temp = load(cookie_file);
    h = temp.h;
end