%{

1) Need to make sure to separate the signing process from any code that
might help with creating the request itself. This is specifically for
general requests. For example creation of the body for a POST request
should not be done with this code, unless via helper functions. The primary
purpose is to create the signed authorization header.

2) I had originally tried to give a lot of power to functions in the
subclass implementation which was supposed to just make everything work. I
have separated this into two processes, initialization of the request and
then signing of the request. This allows the user to have more control over
slight details that need to be changed between the two instead of trying to
have a wrapper function take care of everything.

3) I have methods setAccessToken and setRequestToken to try and funnel
setting all related properties at once, instead of inspecting the hidden
properties

4) Might remove abstract property on getAccessToken and getRequestToken if
they are at all similar between different APIs. Then if an API was
different it could always reimplment. I am not too worried about all this
because the example should be sufficient for most people ...

5) The oauth_params proved to be quite painful to write. Ultimately I
decided on the following things:
- once a parameter is in the property, it is fine
- not to run set method checking, as this made it difficult if I ever read
then wrote the params property
- to have methods which essentially called static methods dependent upon an
option

%}