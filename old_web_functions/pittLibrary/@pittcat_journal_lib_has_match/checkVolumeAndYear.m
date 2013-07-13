function checkVolumeAndYear(obj,j_lib_has_obj,j_obj)
%checkVolumeAndYear
%
%   checkVolumeAndYear(obj,j_obj)
%
%   Populated Properties
%   ===============================================
%   goodVolume   : true if volume matches or no volume
%   goodYear     : true if year matches or no year
%   followsRules : true if goodVolume && goodYear or if both year and
%                  volume are present and fall on the same side of the
%                  reported data, either both before, in the middle, or
%                  after. If this is false it is a strong indication that
%                  this journal is bad ...
%   yearDiff     : Difference between given year and estimated year
%                  based on the range of volumes to the range of years.
%                  This requires both to be present, otherwise a NaN value
%                  is returned.
%                  yearDiff = year_number - year_est;
%                  i.e. + estimate thinks it should be older
%                       - estimate thinks it should be newer
%                  NOTE: This value can be way off if the rate of volumes
%                  published changed at some point, like from quarterly to
%                  yearly, or vice versa.
%
%
%   See Also:
%       pittcat_holding_library_has.populateProperties
%
%   Class: pittcat_journal_lib_has_match

%NOTE: We could also rate the liklihood of this

if j_lib_has_obj.skipped
   return 
end

vol_present = ~isempty(j_obj.volume);
if ~vol_present
    obj.goodVolume = true;
else
    vol_number = str2double(j_obj.volume);
    obj.goodVolume = ~isempty(find(vol_number == j_lib_has_obj.vol_numbers,1));
end

year_present = ~isempty(j_obj.year);
if ~year_present
    obj.goodYear = true;
else
    year_number  = str2double(j_obj.year);
    obj.goodYear = ~isempty(find(year_number == j_lib_has_obj.year_numbers,1));
end

%See pittcat_holding_library_has.populateProperties
year_range = [min(j_lib_has_obj.year_numbers) max(j_lib_has_obj.year_numbers)];
vol_range  = [min(j_lib_has_obj.vol_numbers) max(j_lib_has_obj.vol_numbers)];

if vol_present && year_present && year_range(1) ~= year_range(2)
    %NOTE: We can always estimate year
    if vol_range(1) == vol_range(2)
        if obj.goodYear
            obj.yearDiff = 0;
        else
            obj.yearDiff = NaN; %non-varying year that doesn't match volume
        end
    else
        year_est = interp1(vol_range,year_range,vol_number,'linear','extrap');
        obj.yearDiff = year_number - year_est;
    end
end

if ~obj.goodVolume || ~obj.goodYear && vol_present && year_present
    %BAD SITUTATIONS
    %1) volume before first, but year not
    %2) year before first, but volume not
    %3) volume after last, but year not
    %4) year after first, but volume not
    %NOTICE: I don't use the equality operator, as it is possible
    %to have a year on the border but the volume be past it ...
    %vol 10
    %year 1990
    %for range of vols 11 - #
    %and year range of 1990 -
    %
    if (vol_number < vol_range(1) && year_number > year_range(1)) ...
            || ...
            (vol_number > vol_range(1) && year_number < year_range(1)) ...
            || ...
            (vol_number > vol_range(2) && year_number < year_range(2)) ...
            || ...
            (vol_number < vol_range(2) && year_number > year_range(2))
        obj.followsRules = false;
    end
end


