classdef search < handle
    %
    
    %METHODS IN OTHER FILES
    %======================================
    %   mendeley.lib.search.matchAuthors
    %
    %METHODS
    %======================================
    %   mendeley.lib.search.matchYears
    
    properties
       lib %(Class mendeley_lib)
    end
    
    properties (Dependent)
       n_entries 
    end
    
    methods
        function value = get.n_entries(obj)
           value = obj.lib.n_entries;
        end
    end

    
    methods
        function obj = search(lib_obj)
           if nargin == 0
               return
           end
           obj.lib = lib_obj;
        end
        
        function [I,extras] = matchDocTypes(obj,doc_type_to_match)
           %matchDocTypes 
           %
           %    [I,extras] = matchDocTypes(obj,doc_type_to_match)
           %
           %
           %    OUTPUTS
           %    =============================================
           %    extras
           %        .match_mask
           
           doc_types_in_lib = obj.lib.docType;
           
           extras.match_mask = strcmp(doc_type_to_match,doc_types_in_lib);
           
           I = find(extras.match_mask);
           
        end        
        function [I,extras] = matchYears(obj,year_to_match,varargin)
           %matchYears
           %    
           %    I = matchYears(obj,year_to_match,varargin)
           %
           %    INPUTS
           %    ===============================
           %    year_to_match: (char or #), year to match
           %
           %    OUTPUTS
           %    =============================================
           %    extras
           %        .match_mask
            
           if ischar(year_to_match)
               year_to_match = str2double(year_to_match);
           end
           years_in_lib = obj.lib.year;
           
           extras.match_mask = years_in_lib == year_to_match;
           I = find(extras.match_mask);
        end
        function [matching_entry_indices,extras] = perform_search(obj,varargin)
            
           in.year     = [];
           in.authors  = {};
           in.doc_type = ''; 
           in = processVarargin(in,varargin);
           
           %[I,extras] = matchYears(obj,year_to_match,varargin)
           
           mask = true(1,obj.n_entries);
           extras = []; %handle this later ...
           
           if ~isempty(in.year)
               [~,e_temp] = matchYears(obj,in.year);
               mask = mask & e_temp.match_mask;               
           end
           if ~isempty(in.doc_type)
               [~,e_temp] = matchDocTypes(obj,in.doc_type);
               mask = mask & e_temp.match_mask;
           end
           if ~isempty(in.authors)
              [~,e_temp] = matchAuthors(obj,in.authors);
              mask = mask & e_temp.match_mask;
           end
           
           matching_entry_indices = find(mask);
           
        end
    end
    
end

