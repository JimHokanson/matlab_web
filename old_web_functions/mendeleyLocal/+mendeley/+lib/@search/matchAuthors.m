function [I,extras] = matchAuthors(obj,authors_to_match)
%matchAuthors
%
%   [I,extras] = matchAuthors(obj,authors_to_match)
%
%   INPUTS
%   =======================================
%   authors_match : (cellstr)
%
%   OUTPUTS
%   =======================================
%   I : entries which match perfectly
%   extras
%       .author_mask   - 
%       .nMatches      - 
%       .percent_match - 
%       .match_mask    - 
%
%   Algorithm:
%   =================================
%   
%
%   TODO: Add on more algorithms
%
%   IMPROVEMENTS:
%   ===============================================================
%   - allow western style matching, i.e. remove accents and stuffs
%   ??? strcmp or strfind - use strcmp for now
%   - partial author match - strfind or some lazy string match algorithm

all_authors_in_lib = obj.lib.authors;

%Might need to also remove special characters ...
authors_to_match = lower(authors_to_match);

nAuthorsInput = length(authors_to_match);
nAuthorsInLib = length(all_authors_in_lib);
author_mask = false(nAuthorsInLib,nAuthorsInput);
for iInput = 1:nAuthorsInput
    cur_author = authors_to_match{iInput};
    author_mask(:,iInput) = cellfun(@(x) any(strcmp(x,cur_author)),all_authors_in_lib);
end

nMatches = sum(author_mask,2)'; %NOTE: Flip back to row vector ...

extras.author_mask   = author_mask;
extras.nMatches      = nMatches;
extras.percent_match = nMatches/nAuthorsInput;
extras.match_mask    = nMatches == nAuthorsInput;

I = find(extras.match_mask );

end