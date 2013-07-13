function install
%install  Installs JSOUP jar
%   
%   http://jsoup.org/
%
%   IMPROVEMENTS
%   =========================================================
%   1) Allow static resolution before adding to dynamic path


%s = javaclasspath('-static')
%inStatic = ...
%if inStatic
%   return
%end

my_path = fileparts(mfilename('fullpath'));
d       = dir(fullfile(my_path,'*.jar'));

if length(d) ~= 1
    error('It is expected that there is only one jar file in this directory')
end

javaaddpath(fullfile(my_path,d.name));