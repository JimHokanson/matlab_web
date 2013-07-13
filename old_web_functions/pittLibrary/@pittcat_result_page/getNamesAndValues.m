function getNamesAndValues(obj)
%
%   POPULATES:
%   =================================================================
%   .propNames
%   .propValues
%
%   USES:
%   =================================================================
%   .tr_tags
%
%                         PAGE LAYOUT NOTES
%     ==================================================================
%     1) The page is laid out into headers and values
%     2) Each is encased by a table row
%     3) Some rows don't have headers and are continuations of previous ones 
% 
%     <tr>
%     <th>Location:</th>
%     <td>ULS Storage</td>
%     </tr>
%     <tr>
%     <th>Library has:</th>
%     <td>v1(1990)</td>
%     </tr>
%     <tr>
%     <td>v2,3(1991-1992)<td>
%     <tr>
%
%     %NOTE ON VALIDITY:
%     Need to ignore things like:
%       ======================================================
%     1) EMPTY TH tag
%     <tr> 
%      <th nowrap="" align="RIGHT" valign="TOP"></th> 
%      <td></td>
%     </tr>
%     2) Divider tag ...
%     <tr>
%      <td colspan="2"><a name="D2"></a>
%       <hr width="150" /></td>
%     </tr>

DIVIDER_TAG = 'hr';

tr_tags = obj.tr_tags;

nTrTags = tr_tags.size;

name_all  = cell(1,nTrTags);
value_all = cell(1,nTrTags);
id_all    = zeros(1,nTrTags);

curID = 0;
for iTR = 1:nTrTags
    cur_tr_tag = tr_tags.get(iTR-1);
    temp = cur_tr_tag.children;
    
    name  = '';
    value = '';

    isValid = true;
    
    if temp.isEmpty
        isValid = false;
    else
       nChildren = temp.size;
       for iChild = 1:nChildren
           temp2 = temp.get(iChild - 1);
           
           %NOTE: Values shouldn't exist for missing headers ...
           %This is tested below in the td tag ...
           if strcmp(temp2.tagName,'th')
               name = char(temp2.text);
               name = deblank(name);

               if isempty(name)
                   %do nothing ...
               else
                  assert(name(end) == ':','Assumption of trailing colon violated, please see code')
                  name = name(1:end-1);
                  
                  %Start a new section ...
                  curID = curID + 1;
               end
               
           elseif strcmp(temp2.tagName,'td')
               if ~isempty(value)
                   fprintf(2,'Repeated td tags, see keyboard (goDebug)\n');
                   keyboard
               end
               
               
               divider_tag = temp2.getElementsByTag(DIVIDER_TAG);
               
               if ~divider_tag.isEmpty
                   isValid = false;
                   break
               end

               %Text is the renderable text
               value = char(temp2.text);
               

           else
               %NOTE: I'm only expecting to find th and td tags 
               fprintf(2,'Unhandled tag, see keyboard (goDebug)\n');
               keyboard
           end
       end
       
       %I was running into a tr that looked like this:
% <td></td>
% <td dir="ltr"> v.469(2004)</td>
%- invalid was being set false on the first child, then not true on the second ...
       if isempty(value) && isempty(name)
          isValid = false; 
       end 
              
       name_all{iTR}  = name;
       value_all{iTR} = value;
       if isValid
          id_all(iTR) = curID;
       end
    end
end

has_name  = ~cellfun('isempty',name_all);

obj.propNames  = name_all(has_name);
nNames         = length(obj.propNames);
obj.propValues = cell(1,nNames);

for iID = 1:nNames
   %NOTE: I could speed this up by recording start and stops above
   obj.propValues{iID} = value_all(id_all == iID);
end


end