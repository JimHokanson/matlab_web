function data = getTableDisplay(objs)

nObjs = length(objs);
data  = cell(nObjs,5);

%COLUMN FORMAT:
%===============================
%1) Location - library
%2) Type - 
%3) matching line
%4) same vol
%5) same year

for iObj = 1:nObjs
   cur_obj = objs(iObj);
   cur_holding = cur_obj.holding; 
   data{iObj,1} = cur_obj.location; %Should change this name, things are becoming confusing
   data{iObj,2} = cur_holding.location.type;
   data{iObj,3} = cur_obj.holding_match.lib_has_match_line;
   lib_has_match_obj = cur_obj.holding_match.lib_has_best_match;
   data{iObj,4} = lib_has_match_obj.goodVolume;
   data{iObj,5} = lib_has_match_obj.goodYear;
end



end