function [url,method,body,headers] = http_expandRequestStruct(h)

url = h.url;
method = h.method;
body = h.body;
headers = h.headers;