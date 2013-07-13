function debugStruct = getSignature(obj)
%oauth_getSignature  Adds signature to authorization parameters
%
%   Implements Section 3.4 of Oauth 1.0 Specification   
%
%   debugStruct = getSignature(obj)
%
%   OUTPUTS
%   ======================================================================
%   debugStruct : (struct)
%       .baseString - base string used in creating signature
%       .keyString  - string used to initialize encoder
%
%   See Also:
%       oauth.createBaseString
%       oauth_params.addOauthSignature
%
%   http://tools.ietf.org/html/rfc5849#section-3.4


baseString = createBaseString(obj);

cSecret = obj.consumer_secret;
tSecret = obj.token_secret;

keyString   = [oauth.percentEncodeString(cSecret) '&' oauth.percentEncodeString(tSecret)];
debugStruct = struct('baseString',baseString,'keyString',keyString);            

%Signing 
%--------------------------------------------------------------------
switch obj.opt_signature_method
    case 'HMAC-SHA1'
        javaEncodingName = 'HmacSHA1';
        signingKey = javax.crypto.spec.SecretKeySpec(uint8(keyString),javaEncodingName);
        mac        = javax.crypto.Mac.getInstance(javaEncodingName);
                     mac.init(signingKey)
        rawHmac    = mac.doFinal(uint8(baseString));
        encoder    = org.apache.commons.codec.binary.Base64;
        signature  = char(encoder.encode(typecast(rawHmac,'uint8')))';  %Not sure if typecasting is necessary
    otherwise
        error('Encoding method: %s, not yet supported',obj.signature_method)
end

%Adding signature to params
%-----------------------------------------------------
addOauthSignature(obj.auth_params,signature)





