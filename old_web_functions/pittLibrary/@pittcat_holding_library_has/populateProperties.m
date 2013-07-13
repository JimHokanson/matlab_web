function populateProperties(obj)
%pittcat_entry_parseVolumeYearText Parses a volume/year line in a Pittcat Entry
%
%   parsedInfo = pittcat_entry_parseVolumeYearText(obj,text)
%
%   INPUTS
%   =============================================
%   text: example => v. 62-66 (1939-1943)
%
%   OUTPUTS
%   =============================================
%   parsedInfo: (structure)
%       .vol_numbers  = 62:66;
%       .year_numbers = 1939:1943;
%       .init_regex   = {{'62:66' '1939:1943'}};
%       .raw_line     = 'v. 62-66 (1939-1943)'
%
%   See Also: pittcat_client.parsePittcatEntry
%
%   class: pittcat_holding_library_has

%DOCUMENTATION OF RULES OUT OF DATE
%RULES: assumed format: volume_text(years)
%replace- with :
%remove spaces (should be comma separated)
%split by year and volume
%remove v.
%split volume by pt

text = obj.raw_text;


%JAH TODO: Clean up the filtering a bit in this function ...


%NEW STRATEGY, GRAB FROM v. to end of )
I_START = strfind(text,'v.');
I_END   = strfind(text,')');

if isempty(I_START) || isempty(I_END)
    formattedWarning('Pattern matching of line failed:\nLine: %s',text)
    obj.skipped = true;
    return
end

if I_START(1) ~= 1
    %For Cum. Index case
    formattedWarning('Line expected to start with "v.", skipping\nLine: %s',text)
    obj.skipped = true;
    return
end

filtered_text = text(I_START(1):I_END(1));

%For debugging
raw_filtered_text = filtered_text;

if I_END < length(text)
    formattedWarning('\nDropping text in volume/year parsing:\nOrig: %s\nNew : %s',text,filtered_text)
    obj.dropped_text = text(I_END(1)+1:end);
end

%BRAIN RESEARCH, ULS STORAGE

if isempty(filtered_text)
    error('Empty text line passed in for holdings, likely error in initial parsing, see pittcat_result_page.getNamesAndValues')
end

%Retain : for later
filtered_text(filtered_text == ':') = ';';

filtered_text(filtered_text == '-') = ':';
filtered_text(filtered_text == ' ') = '';
%Splits on ()
temp = regexp(filtered_text,'([^\(].*)\(([^\)].*)\)','tokens');

obj.init_regex   = temp;

if isempty(temp)
    error('Unable to parse volume and year text')
end
if length(temp) > 1
    formattedWarning('Multiple volume/year sets not yet handled')
end

vol_text  = temp{1}{1};
year_text = temp{1}{2};

vol_text = regexprep(vol_text,'v\.','');

parts_remove = {'pt' ';' 'no'};
for iPart = 1:length(parts_remove)
   I = strfind(vol_text,parts_remove{iPart}); 
   if ~isempty(I)
    formattedWarning('Only partial volumes available "%s", case not handled well',vol_text)
    vol_text = vol_text(1:I(1)-1);
    %vol_text = regexprep(vol_text(1:I(1)-1),'[^\d]*','');
    %remove anything not numeric ...
    obj.has_partial_volume_info = true;
   end
end

vol_numbers  = str2num(vol_text); %#ok<*ST2NM>
if isempty(vol_numbers)
    error('Incorrect parsing of line, volume empty: "%s"',filtered_text)
end

%YEAR PARSING
%=======================================================
% % % I = strfind(year_text,';');
% % % if ~isempty(I)
% % %        formattedWarning('Only partial years available "%s", case not handled well',year_text)
% % %        year_text = year_text(1:I(1)-1);
% % %        %year_text = regexprep(year_text(1:I(1)-1),'[^\d]*','');
% % %        obj.has_partial_year_info = true;
% % % end

%Backwards years, wtf ...
%Brain Research 1985-1984

%  	 v.1-6,9-101(1940-1943,1945-1977)
% 	 v.102:no.1, 3-4(1978:Jan.,Mar.-Apr.)
% 	 v.103-111,114-137(1978:May-1981,1982-1989)

%NOTE: ':' is now ';'

year_text = regexprep(year_text,'[^\d:]','');

temp = regexp(year_text,'(\d{4}:\d{4}|\d{4})','tokens');

if isempty(temp)
    error('Incorrect parsing of line, year empty: "%s"',filtered_text)
end

%JAH TODO: Should go back and determine if anything else was present
%use start & stop and cross reference with original text ...
%Create functions for replacing junk with other characters
%and apply separately to year and volume

year_numbers = [];
for iMatch = 1:length(temp)
    cur_match = temp{iMatch}{1};
    if length(cur_match) > 4
        y1 = str2double(cur_match(1:4));
        y2 = str2double(cur_match(6:9));
        if y1 > y2
            year_numbers = [year_numbers y2:y1]; %#ok<*AGROW>
        else
            year_numbers = [year_numbers y1:y2];
        end
    else
        year_numbers = [year_numbers str2double(cur_match)];
    end
end

obj.vol_numbers  = vol_numbers;
obj.year_numbers = year_numbers;

