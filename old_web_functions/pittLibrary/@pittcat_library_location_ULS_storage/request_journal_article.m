function [success,extras] = request_journal_article(obj,pittcat_client_obj,j_obj)
%pittcat_getSubFormString  Gets submission form text
%
%   formPageText = pittcat_getSubFormString(fullQueryURL,getItLink)
%
%   class: pittcat_library_location_ULS_storage < pittcat_library_location

%NOTE: Could add on to extras output with the intermediate text results ...

pcat_user = pittcat_client_obj.user_obj;



%DAMMIT, GET IT LINKS ARE INVALID ON LEAVING THE PAGE ...
pittcat_notifier.status('Obtaining "Get It" Link');
get_it_link = get_Get_It_Link(obj.result_page);

pittcat_notifier.status('Advancing to "Get It" Form');
[get_it_page_text,prev_url_get_it] = pittcat_web_interface.advanceToGetItPage(pcat_user,get_it_link);

pittcat_notifier.status('Submitting Form');
[web_page_text_final_form,prev_url_get_it_form] = pittcat_web_interface.submitGetItOrRecallForm(get_it_page_text,prev_url_get_it,obj,pcat_user);

[success,extras] = pittcat_web_interface.submitGetItRequest(web_page_text_final_form,prev_url_get_it_form,j_obj);

if success
    pittcat_notifier.status('Document successfully requested from ULS Storage!');
else
    %NOTE: Not sure why this would happen ...
    pittcat_notifier.warning('Unable to retrieve document from storage');
end


end

