function h = http_trimCookies(h,N_KEEP)
%http_trimCookies Reduces storage of cookies on computer
%   
%   Serves as a way of getting rid of old cookies. All expired cookies are
%   removed, as well as the cookies with the oldest access.
%
%   CALLING FORMS:
%   ========================================================================
%   1) Normal call, from saveCookie looking to get more space
%   h = http_trimCookies(h,*N_KEEP)
%
%   2) This would be used if calling manually, or say, on startup
%   h = http_trimCookies(*h,*N_KEEP)
%
%   OPTIONAL INPUTS
%   =======================================================================
%   h      : (default []), if not a structure or not passed in the cookie 
%             structure will be loaded from file
%   N_KEEP : (default 50% of init size) # of cookies to keep, we might
%            remove more if a lot have expired, NOTE: Should be a whole #
%            not a percentage
%             
%   See Also:
%       http_getCookiesFromFile

if ~exist('h','var') || isempty(h)
    h = http_getCookiesFromFile;
end

if ~exist('N_KEEP','var')
    N = http_getCookiesFromFile('n');
    N_KEEP = floor(N*0.50);
end

%Determining indices to remove
[~,I_Keep] = sort(h.lastAccess);
I_expired  = find(h.cExpires < now);
I_Keep(ismember(I_Keep,I_expired)) = [];

if length(I_Keep) > N_KEEP
    nRemove = length(I_Keep) - N_KEEP;
    I_Keep(1:nRemove) = [];
end

%Instantiating a new set of cookies, yummmmm
[h2,cookie_file] = http_getCookiesFromFile(true);

%Copying old cookies to new
nKept = length(I_Keep);
fn = fieldnames(h2);
fn(strcmp(fn,'curIndex')) = [];
for iField = 1:length(fn)
   curField = fn{iField};
   h2.(curField)(1:nKept) = h.(curField)(I_Keep); 
end


h2.curIndex = nKept;

h = h2;
save(cookie_file,'h')

end