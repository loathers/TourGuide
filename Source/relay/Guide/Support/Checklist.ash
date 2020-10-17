import "relay/Guide/Support/HTML.ash"
import "relay/Guide/Support/KOLImage.ash"
import "relay/Guide/Support/List.ash"
import "relay/Guide/Support/Page.ash"
import "relay/Guide/Support/Library.ash"
import "relay/Guide/Settings.ash"


record ChecklistSubentry
{
	string header;
	string [int] modifiers;
	string [int] entries;
};


ChecklistSubentry ChecklistSubentryMake(string header, string [int] modifiers, string [int] entries)
{
	boolean all_subentries_are_empty = true;
	foreach key in entries
	{
		if (entries[key] != "")
			all_subentries_are_empty = false;
	}
	ChecklistSubentry result;
	result.header = header;
	result.modifiers = modifiers;
	if (!all_subentries_are_empty)
		result.entries = entries;
	return result;
}

ChecklistSubentry ChecklistSubentryMake(string header, string modifiers, string [int] entries)
{
	if (modifiers == "")
		return ChecklistSubentryMake(header, listMakeBlankString(), entries);
	else
		return ChecklistSubentryMake(header, listMake(modifiers), entries);
}


ChecklistSubentry ChecklistSubentryMake(string header, string [int] entries)
{
	return ChecklistSubentryMake(header, listMakeBlankString(), entries);
}

ChecklistSubentry ChecklistSubentryMake(string header, string [int] modifiers, string e1)
{
	return ChecklistSubentryMake(header, modifiers, listMake(e1));
}

ChecklistSubentry ChecklistSubentryMake(string header, string [int] modifiers, string e1, string e2)
{
	return ChecklistSubentryMake(header, modifiers, listMake(e1, e2));
}


ChecklistSubentry ChecklistSubentryMake(string header, string modifiers, string e1)
{
	if (modifiers == "")
		return ChecklistSubentryMake(header, listMakeBlankString(), listMake(e1));
	else
		return ChecklistSubentryMake(header, listMake(modifiers), listMake(e1));
}

ChecklistSubentry ChecklistSubentryMake(string header)
{
	return ChecklistSubentryMake(header, "", "");
}

void listAppend(ChecklistSubentry [int] list, ChecklistSubentry entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listPrepend(ChecklistSubentry [int] list, ChecklistSubentry entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

ChecklistSubentry [int] listMake(ChecklistSubentry e1)
{
	ChecklistSubentry [int] result;
	result.listAppend(e1);
	return result;
}


record TagGroup
{
    string id; //For the "minimize" feature to keep track of the entries. Uses 'combination' instead if present. Uses the first entry's header if empty.
    string combination; //Entries with identical combination tags will be combined into one, with the "first" taking precedence.
};

int CHECKLIST_DEFAULT_IMPORTANCE = 0;
record ChecklistEntry
{
	string image_lookup_name;
	string url;
    string [string] container_div_attributes;
	ChecklistSubentry [int] subentries;
    TagGroup tags; //meta-informations about the entry
	boolean should_indent_after_first_subentry;
    
    boolean should_highlight;
	
	int importance_level; //Entries will be resorted by importance level before output, ascending order. Default importance is 0. Convention is to vary it from [-11, 11] for reasons that are clear and well supported in the narrative.
    boolean only_show_as_extra_important_pop_up; //only valid if -11 importance or lower - only shows up as a pop-up, meant to inform the user they can scroll up to see something else (semi-rares)
    ChecklistSubentry [int] subentries_on_mouse_over; //replaces subentries
};


ChecklistEntry ChecklistEntryMake(string image_lookup_name, string url, ChecklistSubentry [int] subentries, TagGroup tags, int importance, boolean should_highlight)
{
    ChecklistEntry result;
    result.image_lookup_name = image_lookup_name;
    result.url = url;
    result.subentries = subentries;
    result.tags = tags;
    result.importance_level = importance;
    result.should_highlight = should_highlight;
    return result;
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, TagGroup tags, int importance)
{
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, importance, false);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, TagGroup tags, int importance, boolean [location] highlight_if_last_adventured)
{
    boolean should_highlight = false;
    
    if (highlight_if_last_adventured contains __last_adventure_location)
        should_highlight = true;
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, importance, should_highlight);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, TagGroup tags)
{
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, CHECKLIST_DEFAULT_IMPORTANCE);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, TagGroup tags, boolean [location] highlight_if_last_adventured)
{
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, CHECKLIST_DEFAULT_IMPORTANCE, highlight_if_last_adventured);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, TagGroup tags, int importance)
{
    ChecklistSubentry [int] subentries;
    subentries[subentries.count()] = subentry;
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, importance);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, TagGroup tags, int importance, boolean [location] highlight_if_last_adventured)
{
    ChecklistSubentry [int] subentries;
    subentries[subentries.count()] = subentry;
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, importance, highlight_if_last_adventured);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, TagGroup tags)
{
    return ChecklistEntryMake(image_lookup_name, target_location, subentry, tags, CHECKLIST_DEFAULT_IMPORTANCE);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, TagGroup tags, boolean [location] highlight_if_last_adventured)
{
    ChecklistSubentry [int] subentries;
    subentries[subentries.count()] = subentry;
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, tags, CHECKLIST_DEFAULT_IMPORTANCE, highlight_if_last_adventured);
}


//should we remove these? Players may have build their own ChecklistEntries, so if we do, we'd put a warning here during a release, and officially remove them on the next.
// Considering YOUR speed (yes, you, you know who you are), they'll have, what... a year..? <_<
// ... to change their custom ChecklistEntry / make the right edit(s)
ChecklistEntry ChecklistEntryMake(string image_lookup_name, string url, ChecklistSubentry [int] subentries, int importance, boolean should_highlight)
{
    TagGroup tags;
    return ChecklistEntryMake(image_lookup_name, url, subentries, tags, importance, should_highlight);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, int importance)
{
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance, false);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, int importance, boolean [location] highlight_if_last_adventured)
{
    boolean should_highlight = false;
    
    if (highlight_if_last_adventured contains __last_adventure_location)
        should_highlight = true;
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance, should_highlight);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries)
{
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, CHECKLIST_DEFAULT_IMPORTANCE);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, boolean [location] highlight_if_last_adventured)
{
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, CHECKLIST_DEFAULT_IMPORTANCE, highlight_if_last_adventured);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, int importance)
{
	ChecklistSubentry [int] subentries;
	subentries[subentries.count()] = subentry;
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, int importance, boolean [location] highlight_if_last_adventured)
{
	ChecklistSubentry [int] subentries;
	subentries[subentries.count()] = subentry;
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance, highlight_if_last_adventured);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry)
{
	return ChecklistEntryMake(image_lookup_name, target_location, subentry, CHECKLIST_DEFAULT_IMPORTANCE);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, boolean [location] highlight_if_last_adventured)
{
	ChecklistSubentry [int] subentries;
	subentries[subentries.count()] = subentry;
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, CHECKLIST_DEFAULT_IMPORTANCE, highlight_if_last_adventured);
}

//Secondary level of making checklist entries; setting properties and returning them.
ChecklistEntry ChecklistEntrySetIDTag(ChecklistEntry e, string id)
{
    e.tags.id = id;
    return e;
}

ChecklistEntry ChecklistEntrySetCombinationTag(ChecklistEntry e, string tag)
{
    e.tags.combination = tag;
    return e;
}


void listAppend(ChecklistEntry [int] list, ChecklistEntry entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(ChecklistEntry [int] list, ChecklistEntry [int] entries)
{
	foreach key in entries
		list.listAppend(entries[key]);
}

void listClear(ChecklistEntry [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}


record Checklist
{
	string title;
	ChecklistEntry [int] entries;
    
    boolean disable_generating_id; //disable generating checklist anchor and title-based div identifier
};


Checklist ChecklistMake(string title, ChecklistEntry [int] entries)
{
	Checklist cl;
	cl.title = title;
	cl.entries = entries;
	return cl;
}

Checklist ChecklistMake()
{
	Checklist cl;
	return cl;
}

void listAppend(Checklist [int] list, Checklist entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listRemoveKeys(Checklist [int] list, int [int] keys_to_remove)
{
	foreach i in keys_to_remove
	{
		int key = keys_to_remove[i];
		if (!(list contains key))
			continue;
		remove list[key];
	}
}


string ChecklistGenerateModifierSpan(string [int] modifiers)
{
    if (modifiers.count() == 0)
        return "";
	return HTMLGenerateSpanOfClass(modifiers.listJoinComponents(", "), "r_cl_modifier");
}

string ChecklistGenerateModifierSpan(string modifier) //no longer span, but I'm sure as hell not gonna change every instance of it :V
{
	return HTMLGenerateDivOfClass(modifier, "r_cl_modifier");
}


void ChecklistInit()
{
	PageAddCSSClass("a", "r_cl_internal_anchor", "");
    PageAddCSSClass("", "r_cl_modifier_inline", "font-size:0.85em; color:" + __setting_modifier_colour + ";");
    PageAddCSSClass("", "r_cl_modifier", "font-size:0.85em; color:" + __setting_modifier_colour + "; display:block;");
	
	PageAddCSSClass("", "r_cl_header", "text-align:center; font-size:1.15em; font-weight:bold;");
	PageAddCSSClass("", "r_cl_subheader", "font-size:1.07em; font-weight:bold;");
    PageAddCSSClass("", "r_cl_entry_id", "font-size:1.07em; font-weight:bold; display:none;");
    PageAddCSSClass("div", "r_cl_entry_first_subheader", "display:flex;flex-direction:row;align-items:flex-start;width:100%;");
    PageAddCSSClass("div", "r_cl_entry_container", "display:flex; flex-direction:row; align-items:flex-start; padding-top: var(--cl_entry_container_padding); padding-bottom: var(--cl_entry_container_padding);");
    
    string gradient = "background: #ffffff;background: -moz-linear-gradient(left, #ffffff 50%, #F0F0F0 75%, #F0F0F0 100%);background: -webkit-gradient(linear, left top, right top, color-stop(50%,#ffffff), color-stop(75%,#F0F0F0), color-stop(100%,#F0F0F0));background: -webkit-linear-gradient(left, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);background: -o-linear-gradient(left, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);background: -ms-linear-gradient(left, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);background: linear-gradient(to right, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#F0F0F0',GradientType=1 );"; //help
    PageAddCSSClass("", "container_highlighted", gradient + "margin-right: calc(0px - var(--cl_container_padding)); padding-right: var(--cl_container_padding);"); //counter the checklist_container's padding, so that the gradient won't stop mid-way
    PageAddCSSClass("", "close_highlight", "margin-right: calc(0px - var(--cl_container_padding)); padding-right: var(--cl_container_padding);");
    
    PageAddCSSClass("div", "r_cl_entry_image", "width: var(--image-width); flex:none;");
    PageAddCSSClass("div", "r_cl_entry_content_container", "flex-grow:1;display:flex;flex-direction:column;text-align:left;align-items:flex-start;");
    PageAddCSSClass("", "hr_like", "border: 0px; border-top: 1px; border-style:solid; border-color: " + __setting_line_colour + ";");
    
    //subentries-on-mouseover
    PageAddCSSClass("", "r_cl_entry_content_container.entry_hoverable", "");
    PageAddCSSClass("", "r_cl_entry_content_container.entry_hovered", "display:none;");
    PageAddCSSClass("", "r_cl_entry_container:hover .r_cl_entry_content_container.entry_hoverable", "display:none;");
    PageAddCSSClass("", "r_cl_entry_container:hover .r_cl_entry_content_container.entry_hovered", "display:flex;");
    
    //collapsing feature
    PageAddCSSClass("button", "r_cl_minimize_button", "background-color:antiquewhite;padding:0px;font-size:11px;height:18px;width:18px;flex-shrink:0;position:relative;z-index:2;color:#7F7F7F;cursor:pointer;");
    PageAddCSSClass("button", "r_cl_minimize_button:hover", "background-color:black;");
    
    if (true)
    {
        PageAddCSSClass("", "#Guide_body.opacity_full .r_cl_entry_container.r_cl_collapsed .r_cl_entry_image"
                        + ", #Guide_body.opacity_full .r_cl_entry_container.r_cl_collapsed .r_cl_subheader"
                        + ", #Guide_body.opacity_full .r_cl_entry_container.r_cl_collapsed .r_cl_modifier", "opacity:1;");
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.opacity_full .r_cl_entry_image"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.opacity_full .r_cl_subheader"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.opacity_full .r_cl_modifier", "opacity:1;", 1);
        
        PageAddCSSClass("", "#Guide_body.opacity_half .r_cl_entry_container.r_cl_collapsed .r_cl_entry_image"
                        + ", #Guide_body.opacity_half .r_cl_entry_container.r_cl_collapsed .r_cl_subheader"
                        + ", #Guide_body.opacity_half .r_cl_entry_container.r_cl_collapsed .r_cl_modifier", "opacity:0.5;");
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.opacity_half .r_cl_entry_image"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.opacity_half .r_cl_subheader"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.opacity_half .r_cl_modifier", "opacity:0.5;", 1);
        
        
        //.image_auto on #Guide_body is already the normal behaviour, so don't do anything here (THANKFULLY).
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_large", "display:block;", 1, __setting_media_query_large_size);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_medium"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_small", "display:none;", 1, __setting_media_query_large_size);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_medium", "display:block;", 1, __setting_media_query_medium_size);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_large"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_small", "display:none;", 1, __setting_media_query_medium_size);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_small", "display:block;", 1, __setting_media_query_small_size);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_large"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.image_auto .r_cl_image_container_medium", "display:none;" , 1, __setting_media_query_small_size);
        
        PageAddCSSClass("", "#Guide_body.image_none .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_large"
                        + ", #Guide_body.image_none .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_medium"
                        + ", #Guide_body.image_none .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_small", "display:none;");
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_none .r_cl_image_container_large"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.image_none .r_cl_image_container_medium"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.image_none .r_cl_image_container_small", "display:none;", 1);
        
        PageAddCSSClass("", "#Guide_body.image_small .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_large"
                        + ", #Guide_body.image_small .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_medium", "display:none;");
        PageAddCSSClass("", "#Guide_body.image_small .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_small", "display:block;");
        PageAddCSSClass("", "#Guide_body.image_small .r_cl_entry_container.r_cl_collapsed .r_cl_image_container_small", "display:none;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_small .r_cl_image_container_large"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.image_small .r_cl_image_container_medium", "display:none;", 1);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_small .r_cl_image_container_small", "display:block;", 1);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.image_small .r_cl_image_container_small", "display:none;", 1, __setting_media_query_tiny_size);
        
        
        PageAddCSSClass("", "#Guide_body.collapsing_entries .r_cl_entry_container.r_cl_collapsed .r_cl_subheader"
                        + ", #Guide_body.collapsing_entries .r_cl_entry_container.r_cl_collapsed .r_cl_modifier", "display:block;");
        PageAddCSSClass("", "#Guide_body.collapsing_entries .r_cl_entry_container.r_cl_collapsed .r_cl_entry_id", "display:none;");
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_entries .r_cl_subheader"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_entries .r_cl_modifier", "display:block;", 1);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_entries .r_cl_entry_id", "display:none;", 1);
        
        PageAddCSSClass("", "#Guide_body.collapsing_modifiers .r_cl_entry_container.r_cl_collapsed .r_cl_subheader", "display:block;");
        PageAddCSSClass("", "#Guide_body.collapsing_modifiers .r_cl_entry_container.r_cl_collapsed .r_cl_modifier"
                        + ", #Guide_body.collapsing_modifiers .r_cl_entry_container.r_cl_collapsed .r_cl_entry_id", "display:none;");
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_modifiers .r_cl_subheader", "display:block;", 1);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_modifiers .r_cl_modifier"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_modifiers .r_cl_entry_id", "display:none;", 1);
        
        PageAddCSSClass("", "#Guide_body.collapsing_replace .r_cl_entry_container.r_cl_collapsed .r_cl_subheader"
                        + ", #Guide_body.collapsing_replace .r_cl_entry_container.r_cl_collapsed .r_cl_modifier", "display:none;");
        PageAddCSSClass("", "#Guide_body.collapsing_replace .r_cl_entry_container.r_cl_collapsed .r_cl_entry_id", "display:block;");
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_replace .r_cl_subheader"
                        + ", #Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_replace .r_cl_modifier", "display:none;", 1);
        PageAddCSSClass("", "#Guide_body .r_cl_entry_container.r_cl_collapsed.collapsing_replace .r_cl_entry_id", "display:block;", 1);

        PageAddCSSClass("", "r_cl_entry_container.r_cl_collapsed .r_cl_collapsable", "display:none;");
    }
	
    
    PageAddCSSClass("", "r_cl_image_container_large", "display:block;");
    PageAddCSSClass("", "r_cl_image_container_medium", "display:none;");
    PageAddCSSClass("", "r_cl_image_container_small", "display:none;");
    
	PageAddCSSClass("div", "r_cl_checklist_container", "margin:0px; padding-left: var(--cl_container_padding); padding-right: var(--cl_container_padding); border:1px; border-style: solid; border-color:" + __setting_line_colour + ";border-left:0px; border-right:0px;background-color:#FFFFFF; padding-top:5px;");
    
    //media queries:
    if (true)
    {
        PageAddCSSClass("", "r_cl_image_container_large", "display:none", 0, __setting_media_query_medium_size);
        PageAddCSSClass("", "r_cl_image_container_medium", "display:block;", 0, __setting_media_query_medium_size);
        PageAddCSSClass("", "r_cl_image_container_small", "display:none;", 0, __setting_media_query_medium_size);
        
        PageAddCSSClass("", "r_cl_image_container_large", "display:none", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "r_cl_image_container_medium", "display:none;", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "r_cl_image_container_small", "display:block;", 0, __setting_media_query_small_size);
        
        PageAddCSSClass("", "r_cl_image_container_large", "display:none", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("", "r_cl_image_container_medium", "display:none;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("", "r_cl_image_container_small", "display:none;", 0, __setting_media_query_tiny_size);
        
        
        PageAddCSSClass("", "r_indention", "margin-left:" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "r_indention", "margin-left:" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_tiny_size);
    }
}

//Creates if not found:
Checklist lookupChecklist(Checklist [int] checklists, string title)
{
	foreach key in checklists
	{
		Checklist cl = checklists[key];
		if (cl.title == title)
			return cl;
	}
	//Not found, create one.
	Checklist cl = ChecklistMake();
	cl.title = title;
	checklists.listAppend(cl);
	return cl;
}

void ChecklistFormatSubentry(ChecklistSubentry subentry) {
    foreach i in subentry.entries {
        string [int] line_split = split_string_alternate(subentry.entries[i], "\\|");
        foreach l in line_split {
            if (stringHasPrefix(line_split[l], "*")) {
                // Indent
                line_split[l] = HTMLGenerateIndentedText(substring(line_split[l], 1));
            }
        }

        // Recombine
        buffer building_line;
        boolean first = true;
        boolean last_was_indention = false;
        foreach key in line_split {
            string line = line_split[key];
            if (!contains_text(line, "class=\"r_indention\"") && !first && !last_was_indention) {
                building_line.append("<br>");
            }
            last_was_indention = contains_text(line, "class=\"r_indention\"");
            building_line.append(line);
            first = false;
        }
        subentry.entries[i] = to_string(building_line);
    }
}

buffer ChecklistEntryGenerateContentHTML(ChecklistEntry entry, ChecklistSubentry [int] subentries, string [string] anchor_attributes) {
    buffer entry_content;
    
    string entry_id = entry.tags.id;
    
    boolean first = true;
    boolean indented_after_first_subentry = false;
    boolean entry_is_just_a_title = true;
    foreach j, subentry in subentries {
        if (subentry.header == "")
            continue;
        
        if (first)
        {
            string subheader = HTMLGenerateSpanOfClass(subentry.header, "r_cl_subheader");
            subheader += HTMLGenerateSpanOfClass(entry_id, "r_cl_entry_id");
            
            buffer first_subheader;
            if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable)
                subheader = HTMLGenerateTagWrap("a", subheader, anchor_attributes);
            first_subheader.append(subheader);
            
            //minimize button
            boolean entry_has_content_to_minimize = false;
            int indented_entries;
            foreach j, subentry in subentries {
                if (subentry.header == "")
                    continue;
                
                if (entry.should_indent_after_first_subentry)
                    indented_entries++;
                if (subentry.entries.count() > 0 || indented_entries >= 2) {
                    entry_has_content_to_minimize = true;
                    break;
                }
            }

            first_subheader.append(HTMLGenerateTagWrap("div", "", string [string] {"style":"flex-grow:1;"})); //fill empty space to ensure the button(s) are on the right end

            if (entry_has_content_to_minimize) {
                first_subheader.append(HTMLGenerateTagWrap("button", "&#9660;", string [string] {"class":"r_cl_minimize_button toggle_" + entry_id,"alt":"Minimize","title":"Minimize","id":"toggle_" + entry_id,"onclick":"alterSubentryMinimization(event)", "oncontextmenu":"callSettingsContextualMenu(event)"}));
            }

            entry_content.append(HTMLGenerateTagWrap("div", first_subheader, string [string] {"class":"r_cl_entry_first_subheader"}));
        }
        else if (entry.should_indent_after_first_subentry && !indented_after_first_subentry)
        {
            entry_content.append(HTMLGenerateTagPrefix("div", mapMake("class", "r_indention r_cl_collapsable"))); // + entry_id
            indented_after_first_subentry = true;
        }
        
        if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable) {
            if (subentry.modifiers.count() + subentry.entries.count() > 0 && entry_is_just_a_title) {
                entry_is_just_a_title = false;
                entry_content.append(HTMLGenerateTagPrefix("a", anchor_attributes));
            }
        }
        
        if (!first)
            entry_content.append(HTMLGenerateDivOfClass(subentry.header, "r_cl_subheader"));
        
        if (subentry.modifiers.count() > 0)
            entry_content.append(subentry.modifiers.listJoinComponents(", ").HTMLGenerateDivOfClass("r_indention r_cl_modifier"));

        if (subentry.entries.count() > 0)
        {
            buffer subentry_text;
            for intra_k from 0 to subentry.entries.count() - 1
            { 
                if (intra_k > 0)
                    subentry_text.append("<hr>");
                string line = subentry.entries[listKeyForIndex(subentry.entries, intra_k)];
                
                subentry_text.append(line);
            }
            entry_content.append(HTMLGenerateTagWrap("div", subentry_text, mapMake("class", "r_indention" + (indented_after_first_subentry ? "" : " r_cl_collapsable") ))); // + entry_id
        }
        
        first = false;
    }
    if (indented_after_first_subentry)
        entry_content.append("</div>");
    if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable && !entry_is_just_a_title)
        entry_content.append("</a>");
    return entry_content;
}

/**
Generates HTML for a checklist and appends it to the DOM
@param cl The checklist being appended to the DOM
@param output_borders Whether or not to add borders
*/
buffer ChecklistGenerate(Checklist cl, boolean output_borders) {
	ChecklistEntry [int] entries = cl.entries;
	
	//Combine entries with identical combination tags:
	ChecklistEntry [string] combination_tag_entries;
	foreach key, entry in entries {
		if (entry.tags.combination == "") continue;
        if (entry.only_show_as_extra_important_pop_up) continue; //do not support this feature with this
        if (entry.should_indent_after_first_subentry) continue;
        if (entry.subentries_on_mouse_over.count() > 0) continue;
        if (entry.container_div_attributes.count() > 0) continue;
        
        entry.importance_level -= 1; //combined entries gain a hack; a level above everything else

        if (!(combination_tag_entries contains entry.tags.combination)) {
            entry.tags.id = cl.title + "_" + entry.tags.combination;
            combination_tag_entries[entry.tags.combination] = entry;
            continue;
        }

        ChecklistEntry master_entry = combination_tag_entries[entry.tags.combination];
        
        if (entry.should_highlight) {
        	master_entry.should_highlight = true;
        }

        if (master_entry.url == "" && entry.url != "") {
            master_entry.url = entry.url;
        }

        if (entry.importance_level < master_entry.importance_level)
        {
            master_entry.importance_level = entry.importance_level;
            master_entry.image_lookup_name = entry.image_lookup_name;
            if (entry.url != "")
                master_entry.url = entry.url;

            //Put that entry's subentries at the start
            ChecklistSubentry [int] new_master_subentries = entry.subentries;
            foreach key, subentry in master_entry.subentries {
                new_master_subentries.listAppend(subentry);
            }
            master_entry.subentries = new_master_subentries;
        }
        else
        {
            foreach key, subentry in entry.subentries { 
                master_entry.subentries.listAppend(subentry);
            }
        }

        remove entries[key];
    }
	
	//Sort by importance:
	sort entries by value.importance_level;
	
    //Format subentries:
    foreach index in entries {
        ChecklistEntry entry = entries[index];
        foreach subentryIndex in entry.subentries {
            ChecklistFormatSubentry(entry.subentries[subentryIndex]);
        }
        foreach subentryIndex in entry.subentries_on_mouse_over {
            ChecklistFormatSubentry(entry.subentries_on_mouse_over[subentryIndex]);
        }
    }

	boolean skip_first_entry = false;
	string special_subheader = "";
	if (entries.count() > 0) {
		if (entries[0].image_lookup_name == "special subheader") {
			if (entries[0].subentries.count() > 0) {
				special_subheader = entries[0].subentries[0].header;
				skip_first_entry = true;
			}
		}
	}
	
	buffer result;
    string [string] main_container_map;
    main_container_map["class"] = "r_cl_checklist_container";
    if (!cl.disable_generating_id)
        main_container_map["id"] = HTMLConvertStringToAnchorID(cl.title + " checklist container");
    if (output_borders)
        main_container_map["style"] = "margin-top:12px;margin-bottom:24px;"; //spacing
    else
        main_container_map["style"] = "border:0px;";
    result.append(HTMLGenerateTagPrefix("div", main_container_map));
	
	
    string anchor = cl.title;
    if (!cl.disable_generating_id)
        anchor = HTMLGenerateTagWrap("a", "", mapMake("id", HTMLConvertStringToAnchorID(cl.title), "class", "r_cl_internal_anchor")) + cl.title;
    
	result.append(HTMLGenerateDivOfClass(anchor, "r_cl_header"));
	
	if (special_subheader != "")
		result.append(ChecklistGenerateModifierSpan(special_subheader));
	
	int starting_intra_i = 1;
	if (skip_first_entry)
		starting_intra_i++;
	int intra_i = 0;
	int entries_output = 0;
    boolean last_was_highlighted = false;
    foreach i, entry in entries
    {
        if (++intra_i < starting_intra_i)
            continue;
        entries_output++;
        string [string] anchor_attributes;
        if (entry.url != "")
            anchor_attributes = {"target":"mainpane", "href":entry.url, "class":"r_a_undecorated"};
        
        buffer entry_content;
        string container_class = "r_cl_entry_container";
        if (entry.should_highlight)
            container_class += " container_highlighted";
        if (intra_i > starting_intra_i)
        {
            container_class += " hr_like";
            if (last_was_highlighted && !entry.should_highlight)
                container_class += " close_highlight";
        }
        last_was_highlighted = entry.should_highlight;
        
        if (true) //"Correct" the entry ID
        {
            string entry_id;
            if (entry.tags.combination != "") //not supposed to happen, but still can
                entry_id = entry.tags.combination;
            else if (entry.tags.id != "")
                entry_id = entry.tags.id;
            else
                entry_id = "unIDed_" + entry.subentries[0].header;
            entry_id = create_matcher("[ \\-.,#]", entry_id).replace_all("_");
            entry.tags.id = entity_encode(entry_id);
        }
        
        buffer image_container;
        
        if (true) //image
        {
            image_container.append(KOLImageGenerateImageHTML(entry.image_lookup_name, true, Vec2iMake(__setting_image_width_large, 75), "r_cl_image_container_large"));
            image_container.append(KOLImageGenerateImageHTML(entry.image_lookup_name, true, Vec2iMake(__setting_image_width_medium, 50), "r_cl_image_container_medium"));
            image_container.append(KOLImageGenerateImageHTML(entry.image_lookup_name, true, Vec2iMake(__setting_image_width_small, 50), "r_cl_image_container_small"));
            if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable)
                image_container = HTMLGenerateTagWrap("a", image_container, anchor_attributes);
            image_container = HTMLGenerateTagWrap("div", image_container, mapMake("class", "r_cl_entry_image"));
        }
        
        buffer content;
        
        if (true) //content (text)
        {
            string base_content = entry.ChecklistEntryGenerateContentHTML(entry.subentries, anchor_attributes);
            if (entry.subentries_on_mouse_over.count() == 0)
                base_content = HTMLGenerateTagWrap("div", base_content, mapMake("class", "r_cl_entry_content_container"));
            else
            {
                base_content = HTMLGenerateTagWrap("div", base_content, mapMake("class", "r_cl_entry_content_container entry_hoverable"));
                
                string hover_content = entry.ChecklistEntryGenerateContentHTML(entry.subentries_on_mouse_over, anchor_attributes);
                hover_content = HTMLGenerateTagWrap("div", hover_content, mapMake("class", "r_cl_entry_content_container entry_hovered"));
                content.append(hover_content);
            }
            content.append(base_content);
        }
        
        buffer generated_subentry_html;
        generated_subentry_html.append(image_container);
        generated_subentry_html.append(content);
        
        if (entry.container_div_attributes contains "class")
        {
            if (!entry.container_div_attributes["class"].contains_text(container_class)) //can happen with entries being pinned in the importance bar, passing here twice
                entry.container_div_attributes["class"] += " " + container_class;
        }
        else
            entry.container_div_attributes["class"] = container_class;
        entry.container_div_attributes["class"] += " " + entry.tags.id;
        entry_content.append(HTMLGenerateTagWrap("div", generated_subentry_html, entry.container_div_attributes));

		
		if (anchor_attributes.count() > 0 && __setting_entire_area_clickable)
            entry_content = HTMLGenerateTagWrap("a", entry_content, anchor_attributes);
		
        result.append(entry_content);
	}
	result.append("</div>");
	
	return result;
}

/**
Attaches checklist to DOM.
@param checklist The checklist being appended.
*/
buffer ChecklistGenerate(Checklist checklist) {
    return ChecklistGenerate(checklist, true);
}


Record ChecklistCollection
{
    Checklist [string] checklists;
};

//NOTE: WILL DESTRUCTIVELY EDIT CHECKLISTS GIVEN TO IT
//mostly because there's no easy way to copy an object in ASH
//without manually writing a copy function and insuring it is synched
Checklist [int] ChecklistCollectionMergeWithLinearList(ChecklistCollection collection, Checklist [int] other_checklists)
{
    Checklist [int] result;
    
    boolean [string] seen_titles;
    foreach key, checklist in other_checklists
    {
        seen_titles[checklist.title] = true;
        result.listAppend(checklist);
    }
    foreach key, checklist in collection.checklists
    {
        if (seen_titles contains checklist.title)
        {
            foreach key, checklist2 in result
            {
                if (checklist2.title == checklist.title)
                {
                    checklist2.entries.listAppendList(checklist.entries);
                    break;
                }
            }
        }
        else
        {
            result.listAppend(checklist);
        }
    }
    
    return result;
}

Checklist lookup(ChecklistCollection collection, string name)
{
    if (collection.checklists contains name)
        return collection.checklists[name];
    
    Checklist c = ChecklistMake();
    c.title = name;
    collection.checklists[c.title] = c;
    return c;
}
