classdef pittcat_result_page < handle
    %pittcat_result_page
    %
    %   The page that describes a PittCat Entry. This page generally has a
    %   header describing the item, followed by holding descriptions
    %   (which library, what parts (for journals), Call number, etc). It
    %   also includes some links on the page, like to request it
    %   (get_it_link) and to get more detailed info.
    %
    %   Picture: see 
    %
    %   Extended By:
    %      pittcat_journal_result_page
    %      pittcat_book_result_page NYI
    
    properties
        parent      %(class pittcat_client_journal_search)
        raw_page_text
        prev_url_str
    end
    
    properties
        %get_it_link
        holdings
    end
    
    properties (Hidden)
        tr_tags
        propNames          %(cellstr) property names
        propValues         %cell array of cellstrs, for each property, holds the value/s that follow
        gen_header_struct  %structure of structures, safe field names, fields contain .name (original name) and .values (cellstr)
        gen_holding_struct %structure array, .location and safe fields names " " " "
    end
    
    properties (Constant,Hidden)
        RESULT_START_TEXT = 'NAME=RID'; %<input type="HIDDEN" name="RID" value="520377">
        GET_IT_IMAGE_NAME = '/images/UpRequest.gif'; %name of the image which indicates GET IT button
        LOCATION_NAME     = 'Location'; %Used for dividing between intro and 
    end

    methods
        function initResultObject(obj,page_text,prev_url_str,p_obj)
            %
            %   Function called from specific constructor ...
            %   like: pittcat_journal_result_page
            %
            
            obj.parent        = p_obj;
            obj.raw_page_text = page_text;
            obj.prev_url_str  = prev_url_str;
            initParsing(obj)
            parse(obj)
        end
    end
    
    methods
        function getGenericStructs(obj)
            %Split into header & Results
            %
            %
            %   JAH TODO: Needs documentation
            %
            %   POPULATES:
            %   ---------------------------
            %   .gen_holding_struct
            %   .gen_header_struct
            
            I_LOC_START   = find(strcmp(obj.propNames,obj.LOCATION_NAME));
            I_LOC_END     = [I_LOC_START(2:end) length(obj.propNames)];
            I_last_header = I_LOC_START(1) - 1;

            obj.gen_header_struct = struct;
            for iIndex = 1:I_last_header
                safe_name = genvarname2(obj.propNames{iIndex},'_','v',false);
                obj.gen_header_struct.(safe_name).name   = obj.propNames{iIndex};
                obj.gen_header_struct.(safe_name).values = obj.propValues{iIndex};
            end
            
            obj.gen_holding_struct = struct;
            for iHolding = 1:length(I_LOC_START)
                for iIndex = I_LOC_START(iHolding):I_LOC_END(iHolding)
                    safe_name = genvarname2(obj.propNames{iIndex},'_','v',false);
                    obj.gen_holding_struct(iHolding).(safe_name).name   = obj.propNames{iIndex};
                    obj.gen_holding_struct(iHolding).(safe_name).values = obj.propValues{iIndex};
                end
            end
            
        end

        function value = get_Get_It_Link(obj)
            %
            
            %THIS CODE IS NEEDED BECAUSE OF THE WAY PITTCAT MANANGES ITS SESSION
            
            raw_text = urlread2(obj.prev_url_str);
            
            pittcat_web_interface.checkExpiration(raw_text)
            
            %JAH TODO: Sloppy, could fix, look for <img and closing >???
            html_parser_obj = org.jsoup.parser.Parser.htmlParser;
            
            I_RESULT_START = strfind(raw_text,obj.RESULT_START_TEXT);
            I_GET_IT_IMAGE = strfind(raw_text(1:I_RESULT_START(1)),obj.GET_IT_IMAGE_NAME);
            
            rough_image_boundary_indices = I_GET_IT_IMAGE(1)-200:I_GET_IT_IMAGE(1)+200;
            
            doc_obj2         = parseBodyFragment(html_parser_obj,raw_text(rough_image_boundary_indices),obj.prev_url_str);
            img_tag          = getElementsByAttributeValueContaining(doc_obj2,'src',obj.GET_IT_IMAGE_NAME);
            img_tag_single   = img_tag.get(0);
            value  = char(img_tag_single.parent.absUrl('href')); %Get parent's href value 
        end
        
        function initParsing(obj)
            %initParsing
            %
            %   Populates:
            %   .get_it_link
            %   .
            %
            %   See Also:
            %       pittcat_result_page.getNamesAndValues
            %       pittcat_result_page.getGenericStructs
            %       
            %   class: pittcat_result_page
            
            html_parser_obj = org.jsoup.parser.Parser.htmlParser;
            
            %DO I WANT TO GET THE DETAILED INFO ???????
            
            
            %INITIAL LOCATION PARSING
            I_RESULT_START = strfind(obj.raw_page_text,obj.RESULT_START_TEXT);
            
            
            
            %JAH TODO: error check on size of both -> i.e. not empty
            
            doc_obj     = parseBodyFragment(html_parser_obj,obj.raw_page_text(I_RESULT_START(1):end),obj.prev_url_str);
            table_tags  = getElementsByTag(doc_obj,'table');
            obj.tr_tags = getElementsByTag(table_tags.get(0),'tr');
            
            
            
            
            getNamesAndValues(obj)
            getGenericStructs(obj)
        end
        
    end
    
    methods (Abstract)
        parse(obj)
    end
    
end

