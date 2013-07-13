function setRequestToken(obj,token,secret,varargin)
%setRequestToken Sets request token properties
%
%   setRequestToken(obj,token,secret,varargin)
%
%   INPUTS
%   =========================================================
%   token  : (string), request token value
%   secret : (string)
%
%   OPTIONAL INPUTS
%   ---------------------------------------
%   ttl : (string or numeric)

%Design Note: Wanted set method for a variety of properties
%so that oauth implementations have one function to examine
%for setting the resultant properties

   in.ttl = -1; 
   in = processVarargin(in,varargin);

   if ischar(in.ttl)
       in.ttl = str2double(in.ttl);
   end

   obj.oauth_request_token        = token; 
   obj.oauth_request_token_secret = secret; 
   obj.oauth_request_ttl          = in.ttl;
   obj.oauth_request_set_time     = now;
end