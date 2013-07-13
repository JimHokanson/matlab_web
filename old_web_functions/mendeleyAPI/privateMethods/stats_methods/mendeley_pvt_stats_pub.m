function [output,status,raw] = mendeley_pvt_stats_pub(authStruct)
%mendeley_pvt_stats_pub  Returns
%
%   output = mendeley_pvt_stats_pub(authStruct)
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

url = 'http://api.mendeley.com/oapi/library/publications/';
httpMethod = 'GET';

myParamsPE = {};

[output,status,raw] = mendeley_helper_privateRetrieval(httpMethod,url,authStruct,myParamsPE);
