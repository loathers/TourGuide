import "relay/Guide/Settings.ash"
import "relay/Guide/Support/Library.ash"
import "relay/Guide/Support/IOTMs.ash"
import "relay/Guide/Sections/User Preferences.ash"
import "relay/Guide/Support/Statics.ash"
import "relay/Guide/Support/Statics 2.ash"
import "relay/Guide/Support/List.ash"
import "relay/Guide/Sections/Globals.ash"
import "relay/Guide/Sections/Data.ash"
import "relay/Guide/Support/Counter.ash"
import "relay/Guide/Support/Library 2.ash"
import "relay/Guide/State.ash"
import "relay/Guide/Missing Items.ash"
import "relay/Guide/Support/Math.ash"
import "relay/Guide/Tasks.ash"
import "relay/Guide/Limit Mode/Spelunking.ash"
import "relay/Guide/Daily Resources.ash"
import "relay/Guide/Strategy.ash"
import "relay/Guide/Sections/Messages.ash"
import "relay/Guide/Sections/Checklists.ash"
import "relay/Guide/Sections/Location Bar.ash"
import "relay/Guide/Sections/API.ash"
import "relay/Guide/Sections/Navigation Bar.ash"
import "relay/Guide/Sections/Tests.ash"
import "relay/Guide/Sections/CSS.ash"
import "relay/Guide/Sections/Contextual Menu.ash"
import "relay/Guide/Items of the Month/Items of the Month import.ash"
import "relay/Guide/Paths/Paths import.ash"


void runMain(string relay_filename)
{
	string [string] form_fields = form_fields();
	if (form_fields["API status"] != "")
	{
        string [string] api_response = generateAPIResponse();
        write(api_response.to_json());
        return;
	}
    
	boolean output_body_tag_only = false;
	if (form_fields["body tag only"] != "")
	{
		output_body_tag_only = true;
	}
    else if (form_fields["set user preferences"] != "")
    {
        processSetUserPreferences(form_fields);
        return;
    }
    else if (form_fields.count() > 0)
        print_html("Form fields: " + form_fields.to_json());
	
    
	PageInit();
	ChecklistInit();
    contextMenuInit();
	setUpCSSStyles();
	
	
	Checklist [int] ordered_output_checklists;
	generateChecklists(ordered_output_checklists);
	
    string guide_title = "TourGuide";
    if (limit_mode() == "batman")
        guide_title = "Bat-Guide";
	
	PageSetTitle(guide_title);
	
    if (__setting_use_kol_css)
        PageWriteHead(HTMLGenerateTagPrefix("link", mapMake("rel", "stylesheet", "type", "text/css", "href", "/images/styles.css")));
        
    PageWriteHead(HTMLGenerateTagPrefix("meta", mapMake("name", "viewport", "content", "width=device-width")));
	
	
    if (relay_filename.to_lower_case() == "relay_guide.ash")
        PageSetBodyAttribute("onload", "GuideInit('relay_Guide.ash'," + __setting_horizontal_width + ");");
    else
        PageSetBodyAttribute("onload", "GuideInit('" + relay_filename + "'," + __setting_horizontal_width + ");"); //not escaped
    
    boolean drunk = $item[beer goggles].equipped_amount() > 0;
    
    if (drunk)
        PageWrite(HTMLGenerateTagPrefix("div", mapMake("style", "-webkit-filter:blur(4.0px) brightness(1.01);"))); //FIXME make this animated
    
    boolean buggy = (my_familiar() == $familiar[software bug] || $item[iShield].equipped_amount() > 0);
    if (buggy)
    {
        //Ideally we'd want to layer over a mosaic filter, giving a Cinepak look, but pixel manipulation techniques are limited in HTML.
        string chosen_font;
        //chosen_font = "'Comic Sans MS', cursive, sans-serif;"; //DO NOT USE
        //chosen_font = "'Courier New', Courier, monospace;";
        chosen_font = "'Helvetica Neue',Arial, Helvetica, sans-serif;font-weight:300;";
        PageWrite(HTMLGenerateTagPrefix("div", mapMake("style", "font-family:" + chosen_font)));
        //PageWrite(HTMLGenerateTagPrefix("div", mapMake("style", "")));
        //
    }
    
    boolean displaying_navbar = false;
	if (__setting_show_navbar)
	{
		if (ordered_output_checklists.count() > 1)
			displaying_navbar = true;
	}
	if (displaying_navbar)
	{
        buffer navbar = generateNavbar(ordered_output_checklists);
        PageWrite(navbar);
	}
    
    boolean displaying_location_bar = __setting_show_location_bar;
    if (displaying_location_bar)
    {
        buffer location_bar = generateLocationBar(displaying_navbar);
        if (location_bar.length() == 0)
            displaying_location_bar = false;
        else
            PageWrite(location_bar);
    }
	

	int max_width_setting = __setting_horizontal_width;
	
    string bottom_margin;
    float bottom_offset = (__setting_navbar_height_in_em - 0.05) * (displaying_navbar.to_int() + displaying_location_bar.to_int());
    if (bottom_offset > 0.0)
        bottom_margin = "margin-bottom:" + bottom_offset + "em;";
    
    PageWrite(HTMLGenerateTagPrefix("div", mapMake("class", "r_centre", "id", "Guide_horizontal_container", "style", "position:relative;max-width:" + max_width_setting + "px;" + bottom_margin))); //centre holding container
    
    
    
    if (true)
    {
        //Buttons.
        string [string] base_image_map;
        base_image_map["width"] = "12";
        base_image_map["height"] = "12";
        base_image_map["class"] = "r_button";
        
        //position:fixed holding container for the Close button:
        string [string] image_map = mapCopy(base_image_map);
        image_map["src"] = __close_image_data;
        image_map["onclick"] = "buttonCloseClicked(event)";
        image_map["style"] = "left:5px;top:5px;";
        image_map["id"] = "button_close_box";
        image_map["alt"] = "Close";
        image_map["title"] = image_map["alt"];
        PageWrite(HTMLGenerateTagWrap("div", HTMLGenerateTagPrefix("img", image_map), string [string] {"id":"close_button_position_reference", "style":"position:fixed;z-index:5;width:100%;max-width:" + max_width_setting + "px;"}));
        
        
        //position:absolute holding container, so we can absolutely position these, absolutely:
        PageWrite(HTMLGenerateTagPrefix("div", mapMake("id", "top_buttons_position_reference", "style", "position:absolute;" + "width:100%;max-width:" + max_width_setting + "px;")));
        
        image_map = mapCopy(base_image_map);
        image_map["src"] = __new_window_image_data;
        image_map["id"] = "button_new_window";
        image_map["onclick"] = "buttonNewWindowClicked(event)";
        image_map["style"] = "right:5px;top:5px;";
        image_map["alt"] = "Open in new window";
        image_map["title"] = image_map["alt"];
        PageWrite(HTMLGenerateTagPrefix("img", image_map));
        
        image_map = mapCopy(base_image_map);
        image_map["src"] = __left_arrow_image_data;
        image_map["id"] = "button_arrow_right_left";
        image_map["onclick"] = "buttonRightLeftClicked(event)";
        image_map["style"] = "right:30px;top:5px;";
        image_map["alt"] = "Show chat pane";
        image_map["title"] = image_map["alt"];
        PageWrite(HTMLGenerateTagPrefix("img", image_map));
        
        image_map = mapCopy(base_image_map);
        image_map["src"] = __right_arrow_image_data;
        image_map["id"] = "button_arrow_right_right";
        image_map["onclick"] = "buttonRightRightClicked(event)";
        image_map["style"] = "right:30px;top:5px;";
        image_map["alt"] = "Hide chat pane";
        image_map["title"] = image_map["alt"];
        PageWrite(HTMLGenerateTagPrefix("img", image_map));
        
        image_map = mapCopy(base_image_map);
        image_map["id"] = "button_global_settings";
        image_map["onclick"] = "callSettingsContextualMenu(event)";
        image_map["oncontextmenu"] = "callSettingsContextualMenu(event)";
        image_map["style"] = "right:5px;top:30px;visibility:visible;";
        image_map["alt"] = "Global Settings";
        //image_map["title"] = image_map["alt"]; //useless here
        image_map["aria-hidden"] = "true";
        image_map["focusable"] = "false";
        image_map["data-prefix"] = "fas";
        image_map["data-icon"] = "cog";
        image_map["class"] = image_map["class"] + " svg-inline--fa fa-cog fa-w-16";
        image_map["role"] = "img";
        image_map["xmlns"] = "http://www.w3.org/2000/svg";
        image_map["viewBox"] = "0 0 512 512";
        remove image_map["width"];
        PageWrite(HTMLGenerateTagWrap("svg", '<title>Global Settings</title><path fill="currentColor" d="M487.4 315.7l-42.6-24.6c4.3-23.2 4.3-47 0-70.2l42.6-24.6c4.9-2.8 7.1-8.6 5.5-14-11.1-35.6-30-67.8-54.7-94.6-3.8-4.1-10-5.1-14.8-2.3L380.8 110c-17.9-15.4-38.5-27.3-60.8-35.1V25.8c0-5.6-3.9-10.5-9.4-11.7-36.7-8.2-74.3-7.8-109.2 0-5.5 1.2-9.4 6.1-9.4 11.7V75c-22.2 7.9-42.8 19.8-60.8 35.1L88.7 85.5c-4.9-2.8-11-1.9-14.8 2.3-24.7 26.7-43.6 58.9-54.7 94.6-1.7 5.4.6 11.2 5.5 14L67.3 221c-4.3 23.2-4.3 47 0 70.2l-42.6 24.6c-4.9 2.8-7.1 8.6-5.5 14 11.1 35.6 30 67.8 54.7 94.6 3.8 4.1 10 5.1 14.8 2.3l42.6-24.6c17.9 15.4 38.5 27.3 60.8 35.1v49.2c0 5.6 3.9 10.5 9.4 11.7 36.7 8.2 74.3 7.8 109.2 0 5.5-1.2 9.4-6.1 9.4-11.7v-49.2c22.2-7.9 42.8-19.8 60.8-35.1l42.6 24.6c4.9 2.8 11 1.9 14.8-2.3 24.7-26.7 43.6-58.9 54.7-94.6 1.5-5.5-.7-11.3-5.6-14.1zM256 336c-44.1 0-80-35.9-80-80s35.9-80 80-80 80 35.9 80 80-35.9 80-80 80z"><title>Global Settings</title></path>', image_map)); //https://fontawesome.com/license
        
        image_map = mapCopy(base_image_map);
        image_map["id"] = "button_expand_all";
        image_map["onclick"] = "buttonExpandAllClicked(event)";
        image_map["style"] = "right:30px;top:30px;";
        image_map["alt"] = "Expand all";
        //image_map["title"] = image_map["alt"]; //useless here
        image_map["aria-hidden"] = "true";
        image_map["focusable"] = "false";
        image_map["data-prefix"] = "fas";
        image_map["data-icon"] = "angle-double-down";
        image_map["role"] = "img";
        image_map["class"] = image_map["class"] + " svg-inline--fa fa-angle-double-down fa-w-10";
        image_map["xmlns"] = "http://www.w3.org/2000/svg";
        image_map["viewBox"] = "0 50 320 400";
        remove image_map["width"];
        PageWrite(HTMLGenerateTagWrap("svg", '<title>Expand all</title><path fill="currentColor" d="M143 256.3L7 120.3c-9.4-9.4-9.4-24.6 0-33.9l22.6-22.6c9.4-9.4 24.6-9.4 33.9 0l96.4 96.4 96.4-96.4c9.4-9.4 24.6-9.4 33.9 0L313 86.3c9.4 9.4 9.4 24.6 0 33.9l-136 136c-9.4 9.5-24.6 9.5-34 .1zm34 192l136-136c9.4-9.4 9.4-24.6 0-33.9l-22.6-22.6c-9.4-9.4-24.6-9.4-33.9 0L160 352.1l-96.4-96.4c-9.4-9.4-24.6-9.4-33.9 0L7 278.3c-9.4 9.4-9.4 24.6 0 33.9l136 136c9.4 9.5 24.6 9.5 34 .1z"><title>Expand all</title></path>', image_map)); //https://fontawesome.com/license
        
        PageWrite("</div>");
    }
    
    if (true)
    {
        //Holding container:
        string style = "";
        style += "padding-top:5px;padding-bottom:0.25em;";
        if (!__setting_fill_vertical)
            style += "background-color:" + __setting_page_background_colour + ";";
        if (!__setting_side_negative_space_is_dark && !__setting_fill_vertical)
        {
            style += "border:1px solid;border-top:0px;border-bottom:1px solid;";
            style += "border-color:" + __setting_line_colour + ";";
        }
        PageWrite(HTMLGenerateTagPrefix("div", mapMake("id", "Guide_body", "style", style)));
    }
    
    buffer information_cache;
    
    string player_name = my_name().to_lower_case().HTMLEscapeString();
    if (player_name == "")
        player_name = "anonymous";
    information_cache.append(HTMLGenerateTagWrap("div", player_name, string [string] {"id":"player_name"}));
    
    information_cache.append(HTMLGenerateTagWrap("div", gameday_to_int(), string [string] {"id":"in_game_day"}));
    
    information_cache.append(HTMLGenerateTagWrap("div", my_ascensions(), string [string] {"id":"ascension_count"}));
    
    PageWrite(HTMLGenerateTagWrap("div", information_cache, string [string] {"id":"ASH_information_cache", "style":"display:none;"}));
    
    if (true)
    {
        // Head text
        
        // Title
        PageWrite(HTMLGenerateSpanOfStyle(guide_title, "font-weight:bold; font-size:1.5em"));
        // Day + Turn Count
        if (__misc_state["in run"] && playerIsLoggedIn()) {
            PageWrite(HTMLGenerateDivOfClass("Day " + my_daycount() + ". " + pluralise(my_turncount(), "turn", "turns") + " played.", "r_bold"));
        }
        // Path
        if (my_path() != "" && my_path() != "None" && playerIsLoggedIn()) {
            PageWrite(HTMLGenerateDivOfClass(my_path(), "r_bold"));
        }
        // Random Message (which we'll have to remove :c )
        PageWrite(HTMLGenerateDivOfStyle(generateRandomMessage(), "padding-left:20px;padding-right:20px;"));
        PageWrite(HTMLGenerateTagWrap("div", "", mapMake("id", "extra_words_at_top")));
        // Example mode
        if (__misc_state["Example mode"]) {
            PageWrite("<br>");
            PageWrite(HTMLGenerateDivOfStyle("Example ascension", "text-align:center; font-weight:bold;"));
        }
    }
    
 
	outputChecklists(ordered_output_checklists);
	
    
    if (true)
    {
        //Gray text at the bottom:
        string line;
        line = HTMLGenerateTagWrap("span", "<br>Automatic refreshing disabled.", mapMake("id", "refresh_status"));
        line += HTMLGenerateTagWrap("a", "<br>Created by the almighty Ezandora", generateMainLinkMap("showplayer.php?who=1557284"));
        line += "<br> Forked and maintained by the ASS team";
        line += "<br>" + __version;
        
        PageWrite(HTMLGenerateTagWrap("div", line, mapMake("style", "font-size:0.777em;color:gray;margin-top:-12px;", "id", "Guide_foot")));
        
        if (true)
        {
            //Hacky layout, sorry:
            string [string] image_map;
            image_map["width"] = "12";
            image_map["height"] = "12";
            image_map["class"] = "r_button";
            image_map["src"] = __refresh_image_data;
            image_map["id"] = "button_refresh";
            image_map["onclick"] = "document.location.reload(true)";
            image_map["style"] = "position:relative;top:-12px;right:3px;visibility:visible;";
            image_map["alt"] = "Refresh";
            image_map["title"] = image_map["alt"];
            PageWrite(HTMLGenerateTagWrap("div", HTMLGenerateTagPrefix("img", image_map), mapMake("style", "max-height:0px;width:100%;text-align:right;", "id", "refresh_button_position_reference")));
        }
    }
    boolean matrix_enabled = false;
    if (my_path_id() == PATH_THE_SOURCE || $familiars[dataspider,Baby Bugged Bugbear] contains my_familiar())
    {
        matrix_enabled = !PreferenceGetBoolean("matrix disabled");
        if (true)
        {
            //We support disabling this feature, largely because it causes someone's browser to crash. Probably bad RAM.
            //I personally consider that to be a path-appropriate feature, but...
            string [string] image_map;
            image_map["width"] = "16";
            image_map["height"] = "16";
            image_map["class"] = "r_button";
            image_map["id"] = "button_refresh";
            image_map["style"] = "position:relative;top:-16px;left:3px;visibility:visible;";
            if (matrix_enabled)
            {
                image_map["src"] = __red_pill_image;
                image_map["onclick"] = "setMatrixStatus(true)";
                image_map["alt"] = "Matrix enabled";
            }
            else
            {
                image_map["src"] = __blue_pill_image;
                image_map["onclick"] = "setMatrixStatus(false)";
                image_map["alt"] = "Matrix disabled";
            }
            image_map["title"] = image_map["alt"];
            PageWrite(HTMLGenerateDivOfStyle(HTMLGenerateTagPrefix("img", image_map), "max-height:0px;width:100%;text-align:left;"));
        }
    }
    
    //Contextual menu
    PageWrite(HTMLGenerateTagWrap("div", generateContextualMenu(), string [string] {"class":"menu"}));
    
	PageWrite("</div>");
	PageWrite("</div>");
    
    if (__setting_fill_vertical)
    {
        PageWrite(HTMLGenerateTagWrap("div", "", mapMake("id", "color_fill", "class", "r_vertical_fill", "style", "z-index:-1;background-color:" + __setting_page_background_colour + ";max-width:" + __setting_horizontal_width + "px;"))); //Color fill
        PageWrite(HTMLGenerateTagWrap("div", "", mapMake("id", "vertical_border_lines", "class", "r_vertical_fill", "style", "z-index:-11;border-left:1px solid;border-right:1px solid;border-color:" + __setting_line_colour + ";width:" + (__setting_horizontal_width) + "px;"))); //Vertical border lines, empty background
    }
    PageWriteHead("<script type=\"text/javascript\" src=\"relay_TourGuide.js\"></script>");
    
    if (matrix_enabled)
    {
        PageWrite(HTMLGenerateTagPrefix("div", mapMake("style", "opacity:0;visibility:hidden;background:black;position:fixed;top:0;left:0;z-index:303;width:100%;height:100%;", "id", "matrix_canvas_holder", "onclick", "matrixStopAnimation();", "onmousemove", "matrixStopAnimation();")));
        PageWrite(HTMLGenerateTagWrap("canvas", "", mapMake("width", "1", "height", "1", "id", "matrix_canvas", "style", "")));
        PageWrite("</div>");
        PageWrite(HTMLGenerateTagPrefix("img", mapMake("src", __matrix_glyphs, "id", "matrix_glyphs", "style", "display:none;")));
    }
    
    if (drunk)
        PageWrite("</div>");
    if (buggy)
        PageWrite("</div>");
    
    if (output_body_tag_only)
    	write(PageGenerateBodyContents());
    else
		PageGenerateAndWriteOut();
}
