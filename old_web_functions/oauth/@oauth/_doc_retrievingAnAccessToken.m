%{

retrievingAnAccessToken

NOTE: Each implementation of the oauth class should have a function:
access_token_example()
which should make it REALLY easy to get an access token

The following steps are generally followed to retrieve an access token for
retrieving personal data from users.

OAUTH OUTLINE
--------------------------------------------------------------------------------
- program gets request token then give to user - function getRequestToken
- user authorizes the request token            - function getAuthorizeRequestTokenURL
    NOTE: This means the user is authorizing the program to access the user's contents
- get the access token (done by client)        - function getAccessToken

An access token can then be used until it expires (server controlled, if
ever) or until the user revokes access (interface to doing this is
controlled by the server)


%}