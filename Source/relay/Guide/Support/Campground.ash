import "relay/TourGuide/Support/HTML.ash"

record RestingBonus
{
    string header;
    effect given_effect;
    int duration;
    int limit;

    //Special cases that have particularities not worth mentioning other than setting a quick boolean
    boolean tasteful; //needs 1 or 0 adv. left of its given effect, and breaks after 3-5 uses
};


RestingBonus RestingBonusMake(string header, effect given_effect, int duration, int limit)
{
    RestingBonus result;
    result.header = header;
    result.given_effect = given_effect;
    result.duration = duration;
    result.limit = limit;

    return result;
}

RestingBonus RestingBonusMake(string header, effect given_effect, int duration)
{
    return RestingBonusMake(header, given_effect, duration, 0);
}

RestingBonus RestingBonusMake(string header, int duration)
{
    return RestingBonusMake(header, $effect[none], duration);
}

RestingBonus RestingBonusMake(string header)
{
    return RestingBonusMake(header, 0);
}

RestingBonus RestingBonusMake()
{
    return RestingBonusMake("");
}

RestingBonus RestingBonusIsTasteful(RestingBonus RB)
{
    RB.tasteful = true;
    return RB;
}

RestingBonus [item] __resting_bonuses;
int [item] __campground = get_campground();

void RestingBonusInit()
{
    int holiday_bliss_givers = 0;
    int [int] holiday_bliss = {1:5, 2:10, 3:20, 4:50};
    foreach furniture in __campground {
        switch (furniture) {
            /*
            //want to be sure I have EVERYTHING
            //The "useless to this situation"
            case $item[big rock]: case $item[Newbiesport&trade; tent]: case $item[Barskin tent]: case $item[Cottage]: case $item[Frobozz Real-Estate Company Instant House (TM)]: case $item[Sandcastle]: case $item[House of twigs and spit]:
            case $item[Beanbag chair]: case $item[bed of coals]: case $item[comfy coffin]: case $item[filth-encrusted futon]: case $item[frigid air mattress]: case $item[stained mattress]: case $item[gauze hammock]: case $item[sleeping stocking]: case $item[saltwaterbed]:
            case $item[Meat Maid]: case $item[Clockwork Maid]:
            case $item[Meat golem]:
            case $item[Spooky scarecrow]:
            case $item[Certificate of Participation]:
            case $item[Feng Shui for Big Dumb Idiots]:
            case $item[pagoda plans]:
            case $item[Bonsai tree]:
            case $item[Cuckoo clock]:
            case $item[Tin roof (rusted)]:
            case $item[Meat globe]:
            case $item[Picture of you]:
            case $item[E-Z Cook&trade; oven]: case $item[Dramatic&trade; range]:
            case $item[My First Shaker&trade;]: case $item[Queue Du Coq cocktailcrafting kit]:
            case $item[Sushi-rolling mat]:
            case $item[chef-in-the-box]: case $item[Clockwork Chef-in-the-box]:
            case $item[Bartender-in-the-box]: case $item[Clockwork Bartender-in-the-box]:
            case $item[Discount Telescope Warehouse gift certificate]:
            case $item[Haunted doghouse]:
            case $item[Potted tea tree]:
            case $item[Source terminal]:
            case $item[Witchess Set]:
            case $item[Asdon Martin keyfob]: case $item[Portable Mayo Clinic]: case $item[Little Geneticist DNA-Splicing Lab]: case $item[Diabolic pizza cube]: case $item[Warbear LP-ROM burner]: case $item[Warbear jackhammer drill press]: case $item[Warbear induction oven]: case $item[Warbear high-efficiency still]: case $item[Warbear chemistry lab]: case $item[Warbear auto-anvil]: case $item[Spinning wheel]: case $item[Snow machine]:
            case $item[jar of psychoses (The Crackpot Mystic)]: case $item[jar of psychoses (The Captain of the Gourd)]: case $item[jar of psychoses (The Meatsmith)]: case $item[jar of psychoses (The Pretentious Artist)]: case $item[jar of psychoses (The Suspicious-Looking Guy)]: case $item[jar of psychoses (The Old Man)]: case $item[jar of psychoses (Jick)]:
            case $item[El Vibrato trapezoid]:
            case $item[packet of pumpkin seeds]: case $item[Peppermint Pip Packet]: case $item[packet of dragon's teeth]: case $item[packet of beer seeds]: case $item[packet of winter seeds]: case $item[packet of thanksgarden seeds]: case $item[packet of tall grass seeds]: case $item[packet of mushroom spores]:
                break;
            default:
                __resting_bonuses[furniture] = RestingBonusMake(); //they are in a mafia version where mafia recognizes the campground furniture, but we didn't add it to this list yet
                break;
            */ //Bad idea. get_campground() also lists what you'd get out of your campground at any given point, as items, and that looks too boring to list. Was already getting a lot anyway. Not deleted just in case
            case $item[Giant pilgrim hat]:
                __resting_bonuses[$item[Giant pilgrim hat]] = RestingBonusMake("a random effect", 15);
                break;
            case $item[BRICKO pyramid]:
                __resting_bonuses[$item[BRICKO pyramid]] = RestingBonusMake("+100% weapon/spell dmg", $effect[Pyramid Power], 20, 3);
                break;
            case $item[Ginormous pumpkin]:
                __resting_bonuses[$item[Ginormous pumpkin]] = RestingBonusMake("+20% Item, +10 Spooky Dmg, +10 ML", $effect[Juiced and Jacked], 10, 1);
                break;
            case $item[Giant Faraday cage]:
                __resting_bonuses[$item[Giant Faraday cage]] = RestingBonusMake("+50 MP, 5-8 MP regen", $effect[Uncaged Power], 30, 1);
                break;
            case $item[Snow fort]:
                __resting_bonuses[$item[Snow fort]] = RestingBonusMake("+25% Item, +50% Meat, +100 HP, +50 MP", $effect[Snow Fortified], 10, 1);
                break;
            case $item[Elevent]:
                __resting_bonuses[$item[Elevent]] = RestingBonusMake("+11% stats, +11% init, +11% item, +11% meat, +11 weapon/spell dmg, +11 HP/MP, +11 DR", $effect[It's Ridiculous], 11, 1);
                break;
            case $item[Gingerbread house]:
            case $item[Crimbo wreath]:
            case $item[string of Crimbo lights]:
            case $item[plastic Crimbo reindeer]:
                __resting_bonuses[$item[Gingerbread house]] = RestingBonusMake("+20% Item, +20% Meat", $effect[Holiday Bliss], holiday_bliss [++holiday_bliss_givers], 1);
                break;
            case $item[Hobo fortress blueprints]:
                __resting_bonuses[$item[Hobo fortress blueprints]] = RestingBonusMake("+5 hobo power", $effect[Hobonic], 10);
                break;
            case $item[Xiblaxian residence-cube]:
                __resting_bonuses[$item[Xiblaxian residence-cube]] = RestingBonusMake("+100 MP, 10-20 MP regen", $effect[Hypercubed], 50, 1);
                break;
            case $item[House-sized mushroom]:
                __resting_bonuses[$item[House-sized mushroom]] = RestingBonusMake("+25% stats, +25% init, +1 all res", $effect[Mushed], 20, 1);
                break;
            case $item[Lazybones&trade; recliner]:
                __resting_bonuses[$item[Lazybones&trade; recliner]] = RestingBonusMake("+25% stats, +25 spooky dmg", $effect[Bonelording], 20, 1);
                break;
            case $item[Spirit bed]:
                __resting_bonuses[$item[Spirit bed]] = RestingBonusMake("+20% MP", $effect[Spirit Schooled], 20, 1);
                break;
            case $item[Lucky cat statue]:
                __resting_bonuses[$item[Lucky cat statue]] = RestingBonusMake("+5% Item", $effect[Lucky Cat Is Lucky], 5, 1); //SETS the remaining duration of that effect to 5 adv
                break;
            case $item[Confusing LED clock]:
                __resting_bonuses[$item[Confusing LED clock]] = RestingBonusMake(HTMLGenerateSpanFont("+5 PVP fights, -5 adventures", "red"), $effect[none], 0, 1);
                break;
            case $item[Black-and-blue light]:
                __resting_bonuses[$item[Black-and-blue light]] = RestingBonusMake("2-5 HP regen", $effect[Less Vincible], 5).RestingBonusIsTasteful();
                break;
            case $item[Blue plasma ball]:
                __resting_bonuses[$item[Blue plasma ball]] = RestingBonusMake("1-5 phys. react. passive dmg", $effect[Stuck-Up Hair], 5).RestingBonusIsTasteful();
                break;
            case $item[Loudmouth Larry Lamprey]:
                __resting_bonuses[$item[Loudmouth Larry Lamprey]] = RestingBonusMake("3-5 MP regen", $effect[In Tuna], 5).RestingBonusIsTasteful();
                break;
        }
    }
}

RestingBonusInit();
