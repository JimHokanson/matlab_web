function search(obj,varargin)
%search
%
%   search(obj,varargin)
%
%   OPTIONAL INPUTS
%   ==================================================================
%   show_GUI: (default false, if true shows the results as a GUI)
%   
%
%   POSSIBLE IMPROVEMENTS
%   ==================================================================
%   - might change to allow searching for books as well, currently is
%   assumes a search for a journal article ...
%
%   See Also:
%   pittcat_client_journal_search.search
%
%
%   class: pittcat_client

in.show_GUI = false;
in = processVarargin(in,varargin);

if obj.in_gui_mode
    pittcat_notifier.clear;
end

obj.search_obj = pittcat_client_journal_search.search(obj);

if ~obj.search_obj.search_started
    return
end

if in.show_GUI
    show_search_results_gui(obj)
end