function [output,status,raw] = mendeley_pvt_stats_tag(authStruct)
%mendeley_pvt_userAuthored  Returns
%
%   output = mendeley_getUserLibrary(authStruct)
%   
%   OUTPUTS
%   =======================================================================
%   output = 
%      total_results: 1
%        total_pages: 1
%       current_page: 0
%     items_per_page: 20
%       document_ids: {'2937576181'}
%
%   INPUTS
%   =======================================================================
%   authStruct   : see oauth_createAuthStruct
%
%   See Also: 

url = 'http://api.mendeley.com/oapi/library/tags/';
httpMethod = 'GET';

myParamsPE = {};

[output,status,raw] = mendeley_helper_privateRetrieval(httpMethod,url,authStruct,myParamsPE);