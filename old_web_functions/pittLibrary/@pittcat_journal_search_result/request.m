function [success,extras] = request(obj,varargin)
%request
%
%   class: pittcat_journal_search_result

in.save_success = true;
in = processVarargin(in,varargin);

location = obj.holding.location;

%   pittcat_library_location_ULS_storage.request_journal_article
%   pittcat_library_location_HSLS_storage.request_journal_article
%   pittcat_library_location_ULS_Library.request_journal_article
%

[success,extras] = request_journal_article(location,obj.requesting_client,obj.j_obj);

%MOVE TO FUNCTION ABVOE ...
if success && in.save_success
   saveRequestToFile(obj) 
end
