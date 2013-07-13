function nonce = getNonce()
%getNonce Returns nonce as string
%
%   nonce = getNonce()
%
%   NOTE: nonce is a random string that is used only once
%   Implementation of this can vary ...


   nonce  = strrep([num2str(now) num2str(rand)], '.', '');
end