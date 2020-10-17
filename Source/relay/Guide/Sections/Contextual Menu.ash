
void contextMenuInit()
{
    PageAddCSSClass("div", "menu", "position:absolute; border:5px double; padding:0px 10px 5px; z-index:4; background:ghostwhite; display:none; flex-direction:column;");
    PageAddCSSClass("div", "ct_menu_choice_group", "display:flex; flex-direction:column; margin-top:5px;");
    PageAddCSSClass("div", "ct_menu_choice", "display:inline-flex; flex-flow:row wrap; justify-content:center; align-items:center;");
    PageAddCSSClass("", "ct_menu_choice_subheader", "width:100%; margin-bottom:5px;"); //text-decoration:underline; ?
    PageAddCSSClass("", "ct_menu_choice_label", ""); //width:50%; text-align:right;
    PageAddCSSClass("", "ct_menu_choice_setting", "width:auto; overflow:hidden; font-size:1em;"); //width:50%; //for some reason, they don't inherit size, so set it

}

buffer generateContextualMenuChoice(string choice_label, string choice_id, string [string] option_values)
{
    buffer choice;
    choice.append(HTMLGenerateTagWrap("label", choice_label, string [string] {"class":"ct_menu_choice_label", "for":choice_id}));

    buffer options;
    options.append(HTMLGenerateTagWrap("option", "", string [string] {"value":"default", "id":"default_" + choice_id, "style":"display:none;"}));
    foreach choice_value, choice_text in option_values
    {
        options.append(HTMLGenerateTagWrap("option", choice_text, string [string] {"value":choice_value}));
    }

    choice.append(HTMLGenerateTagWrap("select", options, string [string] {"id":choice_id, "class":"ct_menu_choice_setting", "onchange":"registerSettingsChange(event)"}));
    return HTMLGenerateTagWrap("div", choice, string [string] {"class":"ct_menu_choice"});
}

buffer generateContextualMenu()
{
    //Minimization-specific contextual menu
    buffer guide_contextual_menu;
    
    buffer guide_contextual_menu_header;
    guide_contextual_menu_header.append(HTMLGenerateTagWrap("div", "", string [string] {"id":"contextual_menu_header_text", "style":"flex-grow:1; font-size:1.07em; font-weight:bold; padding-bottom:5px; word-wrap:anywhere;"}));
    guide_contextual_menu_header.append(HTMLGenerateTagWrap("div", "?", string [string] {"id":"settings_help_button", "title":entity_encode('"What is this?"'), "style":"margin-left:-8px; width:1.2em; border:1px solid; border-radius:1em; background-color:lightcyan; cursor:pointer; flex-shrink:0;", "onclick":"alterSettingsHelpDisplay()"}));
    
    guide_contextual_menu.append(HTMLGenerateTagWrap("div", guide_contextual_menu_header, string [string] {"id":"contextual_menu_header", "style":"display:flex; flex-direction:row-reverse; align-items:center; margin-bottom:5px; border-bottom:2px solid;"}));
    //guide_contextual_menu.append(HTMLGenerateTagWrap("span", "", string [string] {"id":"contextual_menu_trace", "style":"margin-bottom:2px;"})); //cur. unused
    //guide_contextual_menu.append(HTMLGenerateTagWrap("span", "", string [string] {"id":"contextual_menu_current_node", "style":"margin-bottom:2px;"}));
    //guide_contextual_menu.append(HTMLGenerateTagWrap("div", "", string [string] {"id":"contextual_menu_next_nodes", "style":"margin-bottom:2px;"})); //cur. unused


    if (true)
    {
        //auto-expansion choices
        buffer choice_group;
        choice_group.append(HTMLGenerateTagWrap("div", "Auto-expansion", string [string] {"class":"ct_menu_choice_subheader"}));
        choice_group.append(generateContextualMenuChoice("At rollover", "rollover_AE", string [string] {"true":"yes","false":"no"}));
        choice_group.append(generateContextualMenuChoice("On ascension", "ascension_AE", string [string] {"true":"yes", "false":"no"}));

        guide_contextual_menu.append(HTMLGenerateTagWrap("div", choice_group, string [string] {"class":"ct_menu_choice_group", "id":"auto_expansion_choice_group"}));
    }
    if (true)
    {
        //when minimized choices
        buffer choice_group;
        choice_group.append(HTMLGenerateTagWrap("div", "When minimized", string [string] {"class":"ct_menu_choice_subheader"}));
        choice_group.append(generateContextualMenuChoice("Opacity", "opacity", string [string] {"half":"halve opacity","full":"keep full opacity"}));
        choice_group.append(generateContextualMenuChoice("Tile image", "image", string [string] {"none":"don't display", "small":"display smallest", "auto":"don't change image size"}));
        choice_group.append(generateContextualMenuChoice("Content to show", "collapsing", string [string] {"entries":"title", "modifiers":"title + subtitle", "replace":"replace all with tile ID"}));
        guide_contextual_menu.append(HTMLGenerateTagWrap("div", choice_group, string [string] {"class":"ct_menu_choice_group", "id":"auto_expansion_choice_group"}));
    }

    if (true)
    {
        //info
        buffer help_text;
        help_text.append("- Right-click on the minimize button of a tile to open the settings for that specific tile.");
        help_text.append("<br><br>- Neither the Minimize nor the Settings feature will work if you don't set your browser to be able to store data.");
        help_text.append("<br>- Everything is saved in LocalStorage. To access it, right-click anywhere => inspect element => Storage => Local Storage (Firefox), or right-click anywhere => inspect => Application => Storage => Local Storage (Edge/Chrome).");
        help_text.append("<br>- If you're actually relying on this feature, make sure you note its value every once in a while; if there's ever a release that changes their syntax, they'll get erased!.");
        help_text.append("<br>- Deleting your browser's cache will also wipe out everything.");
        help_text.append("<br><br>- Where do you think this feature should be headed next? Let me know!");
        help_text.append("<br><br>&hearts; -- " + HTMLGenerateTagWrap("a", "fredg1", generateMainLinkMap("showplayer.php?who=3041087")));
        guide_contextual_menu.append(HTMLGenerateTagWrap("div", help_text, string [string] {"id":"ct_menu_help", "style":"display:none;"}));
    }

    //the rest of the computation happens in the .js
    return guide_contextual_menu;
}