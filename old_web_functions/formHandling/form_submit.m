function [web_page_text,extras] = form_submit(formStruct,varargin)
%form_submit  Submits a POST or GET form
%
%   [web_page_text,extras] = form_submit(formStruct)
%
%   [jsoup_doc,extras] = form_submit(formStruct) 
%        See optional inputs ...
%
%   NOTE: This function only currently supports GET & POST methods
%
%   INPUTS
%   =======================================================================
%   formStruct : (structure) see form_get
%
%   OPTIONAL INPUTS
%   ======================================================================
%   headers
%   add_button
%   return_jsoup
%
%   OUTPUTS
%   =======================================================================
%   web_page_text : result returned from http query
%   extras : (structure)
%       .allHeaders     - headers returned during request
%       .status         - status of the request
%       .url            - url used in request
%       .params_values  - parameters and values used for request
%
%   See Also:
%     form_get
%     form_createRequest
%     http_paramsToQuery
%     http_makeGetUrl
%     form_helper_chooseButton
%     form_helper_selectCheckBox
%     form_helper_selectOption
%     form_helper_selectRadio
%     form_helper_setTextValue

in.headers      = [];
in.add_button   = true;
in.return_jsoup = false;
in = processVarargin(in,varargin);

if length(formStruct) ~= 1
    error('The form input struct must only contain one element')
end

[url,method,params_values] = form_createRequest(formStruct,'add_button',in.add_button);

if ~(strcmpi(method,'GET') || strcmpi(method,'POST'))
    error('This function only supports the GET or POST methods, not %s',method)
end

switch upper(method)
    case 'GET'
        newURL = http_makeGetUrl(url,params_values);
        [web_page_text,extras] = urlread2(newURL,method,'',in.headers);
    case 'POST'
        [queryString,header]   = http_paramsToString(params_values,1);
        if ~isempty(in.headers)
           header = [header in.headers]; 
        end
        [web_page_text,extras] = urlread2(url,method,queryString,header);
    otherwise
        error('Method: %s, not yet handled')
end

extras.params_values = params_values;

if in.return_jsoup
   extras.raw_text = web_page_text;
   web_page_text   = jsoup_get_doc(web_page_text,extras.url);
end

