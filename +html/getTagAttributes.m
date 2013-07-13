function attr_struct = getTagAttributes(jsoup_tag_obj)
%
%   attr_struct = html.getTagAttributes(jsoup_tag_obj)
%
%   INPUTS
%   ========================================================
%   jsoup_tag_obj : Class : org.jsoup.nodes.Element

attributes_list = jsoup_tag_obj.attributes.asList;
%Class: java.util.Collections

attr_struct = struct;

n_attributes = attributes_list.size;

for iAttr = 0:(n_attributes-1)
   temp  = attributes_list.get(iAttr);
   %Class: org.jsoup.nodes.Attribute
   
   name  = temp.getKey;
   value = temp.getValue;
   
   name(name == '-')  = '_';
   attr_struct.(name) = value;
end