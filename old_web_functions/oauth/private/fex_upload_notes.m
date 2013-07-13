%Jim's FEX Notes

%****** fAll2 is what I care about ************************


f = cell(1,3);

f{1} = mydepfun('oauth',true,true);
f{2} = mydepfun('mendeley_oauth',true,true);
f{3} = mydepfun('oauth_params',true,true);

fAll = vertcat(f{:});

d = cell(1,3);
d{1} = fileparts(which('oauth'));
d{2} = fileparts(which('mendeley_oauth'));
d{3} = fileparts(which('oauth_params'));

for i = 1:3
mask = strncmp(fAll,d{i},length(d{i}));
fAll(mask) = [];
end

fAll = unique(fAll);
[~,fAll2] = cellfun(@fileparts,fAll,'un',0);

