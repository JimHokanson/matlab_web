function time_t = getTimestamp
%getTimestamp Returns OAuth timestamp string
%
%   time_t = getTimestamp
%
%   OUTPUTS
%   ===========================================================
%   time_t: (string) Unix Time => seconds since January 1, 1970

time_t = int2str((java.lang.System.currentTimeMillis)/1000);