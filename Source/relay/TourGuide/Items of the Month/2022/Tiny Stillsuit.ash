//Tiny stillsuit
RegisterResourceGenerationFunction("IOTMTinyStillsuitResource");
void IOTMTinyStillsuitResource(ChecklistEntry [int] resource_entries)
{
  int fam_sweat_o_meter = get_property_int("familiarSweat");

  // Cannot drink the distillate until you have 10+ drams.
  if (!lookupItem("tiny stillsuit").have() || fam_sweat_o_meter < 10 ) return;
  
  string title;
  string [int] description;
  string url = "inventory.php?action=distill&pwd=" + my_hash();
  title = HTMLGenerateSpanFont(fam_sweat_o_meter + " drams of stillsuit sweat", "purple");
  description.listAppend("Two gross tastes that taste horrible together.");
 
  if (fam_sweat_o_meter > 358 && __misc_state["in run"]) {
    description.listAppend("" + HTMLGenerateSpanOfClass("11", "r_bold") + " advs when guzzling now (costs 1 liver).");
    description.listAppend("You should probably guzzle your sweat now.");
  }
  else
  {
    int sweatAdvs = round(fam_sweat_o_meter ** 0.4);
    int nextSweatDrams = ceil((sweatAdvs + 1) ** 2.5);
    description.listAppend("" + HTMLGenerateSpanOfClass(sweatAdvs, "r_bold") + " advs when guzzling now (costs 1 liver).");
    description.listAppend("" + HTMLGenerateSpanOfClass(nextSweatDrams - fam_sweat_o_meter, "r_bold") + " more sweat until +1 more adventure. (" + ceil(nextSweatDrams - fam_sweat_o_meter)/3 + " combats on current familiar)");
  }
  
  if ($item[tiny stillsuit].item_amount() == 1) {
    description.listAppend("" + HTMLGenerateSpanFont("Not collecting sweat from any familiar right now.", "red") + "");
    url = "familiar.php";
  } 
  else if ($item[tiny stillsuit].equipped_amount() == 1)
  {
    description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat from current familiar!", "purple") + "");
  }
  else
  {
    description.listAppend("" + HTMLGenerateSpanFont("Currently collecting sweat on a different familiar!", "fuchsia") + "");
  }
    
  resource_entries.listAppend(ChecklistEntryMake("__item tiny stillsuit", url, ChecklistSubentryMake(title, description), -2).ChecklistEntrySetIDTag("tiny stillsuit resource"));
}