//lucky megatile
RegisterResourceGenerationFunction("LuckyMegatileGenerateResource");
void LuckyMegatileGenerateResource(ChecklistEntry [int] resource_entries)
{
	string url;
	string [int] description;
	{
		int Luckos;
		
		int Saxos = clampi(3 - get_property_int("_aprilBandSaxUses"), 0, 3);
		boolean Scepto = get_property_boolean("_aug2Cast");
		int AEDos = available_amount($item[[10883]astral energy drink]);
		int Clovos = available_amount($item[11-leaf clover]);
		boolean Pillo = get_property_boolean("_freePillKeeperUsed");
		int Lindos = clampi(3 - get_property_int("_speakeasyDrinksDrunk"), 0, 3);
		boolean HotDoggo = get_property_boolean("_fancyHotDogEaten");
		
			description.listAppend(HTMLGenerateSpanFont("Prepare a Lucky adventure!", "green"));
			if (Saxos > 0 && available_amount($item[apriling band saxophone]) > 0) {
				Luckos += Saxos;
				description.listAppend(HTMLGenerateSpanOfClass(Saxos, "r_bold") + "x Apriling Sax plays");
			}
			if (!Scepto && available_amount($item[august scepter]) > 0) {
				if (!Scepto) {
					Luckos += 1;
				}
				description.listAppend(HTMLGenerateSpanOfClass("1", "r_bold") + "x August Scepter Clover");
			}
			if (AEDos > 0) {
				Luckos += AEDos;
				description.listAppend(HTMLGenerateSpanOfClass(AEDos, "r_bold") + "x astral energy drink (5 spleen)");
			}
			if (Clovos > 0) {
				Luckos += Clovos;
				description.listAppend(HTMLGenerateSpanOfClass(Clovos, "r_bold") + "x 11-leaf clovers");
			}
			if (!Pillo && available_amount($item[Eight Days a Week Pill Keeper]) > 0) {
				if (!get_property_boolean("_freePillKeeperUsed")) {
					Luckos += 1;
				}
				description.listAppend(HTMLGenerateSpanOfClass("1", "r_bold") + "x free pill keeper pill");
			}
			if (Lindos > 0 && available_amount($item[Clan VIP Lounge key]) > 0) {
				Luckos += Lindos;
				description.listAppend(HTMLGenerateSpanOfClass(Lindos, "r_bold") + "x Lucky Lindys (6 drunk)");
			}
			if (!HotDoggo && available_amount($item[Clan VIP Lounge key]) > 0) {
				if (!get_property_boolean("_fancyHotDogEaten")) {
					Luckos += 1;
				}
				description.listAppend(HTMLGenerateSpanOfClass("1", "r_bold") + "x optimal dog");
			}
		
		if (Luckos > 0) {	
			resource_entries.listAppend(ChecklistEntryMake("__item 11-leaf clover", "", ChecklistSubentryMake(Luckos + "x Lucky adventures possible", "", description), -2));
		}
	}
}
