import "relay/Guide/Support/Math.ash"
import "relay/Guide/Support/List.ash"

buffer to_buffer(string str)
{
	buffer result;
	result.append(str);
	return result;
}

buffer copyBuffer(buffer buf)
{
    buffer result;
    result.append(buf);
    return result;
}

//split_string returns an immutable array, which will error on certain edits
//Use this function - it converts to an editable map.
string [int] split_string_mutable(string source, string delimiter)
{
	string [int] result;
	string [int] immutable_array = split_string(source, delimiter);
	foreach key in immutable_array
		result[key] = immutable_array[key];
	return result;
}

//This returns [] for empty strings. This isn't standard for split(), but is more useful for passing around lists. Hacky, I suppose.
string [int] split_string_alternate(string source, string delimiter)
{
    if (source.length() == 0)
        return listMakeBlankString();
    return split_string_mutable(source, delimiter);
}

string slot_to_string(slot s)
{
    if (s == $slot[acc1] || s == $slot[acc2] || s == $slot[acc3])
        return "accessory";
    else if (s == $slot[sticker1] || s == $slot[sticker2] || s == $slot[sticker3])
        return "sticker";
    else if (s == $slot[folder1] || s == $slot[folder2] || s == $slot[folder3] || s == $slot[folder4] || s == $slot[folder5])
        return "folder";
    else if (s == $slot[fakehand])
        return "fake hand";
    else if (s == $slot[crown-of-thrones])
        return "crown of thrones";
    else if (s == $slot[buddy-bjorn])
        return "buddy bjorn";
    return s;
}

string slot_to_plural_string(slot s)
{
    if (s == $slot[acc1] || s == $slot[acc2] || s == $slot[acc3])
        return "accessories";
    else if (s == $slot[hat])
        return "hats";
    else if (s == $slot[weapon])
        return "weapons";
    else if (s == $slot[off-hand])
        return "off-hands";
    else if (s == $slot[shirt])
        return "shirts";
    else if (s == $slot[back])
        return "back items";
    
    return s.slot_to_string();
}


string format_today_to_string(string desired_format)
{
    return format_date_time("yyyyMMdd", today_to_string(), desired_format);
}


boolean stringHasPrefix(string s, string prefix)
{
	if (s.length() < prefix.length())
		return false;
	else if (s.length() == prefix.length())
		return (s == prefix);
	else if (substring(s, 0, prefix.length()) == prefix)
		return true;
	return false;
}

boolean stringHasSuffix(string s, string suffix)
{
	if (s.length() < suffix.length())
		return false;
	else if (s.length() == suffix.length())
		return (s == suffix);
	else if (substring(s, s.length() - suffix.length()) == suffix)
		return true;
	return false;
}


static string [int] __uniwords_to_cardinal_map;
static string [int] __tens_to_cardinal_map;
string tens_to_cardinal(int value, boolean is_following_digits_of_larger_number)
{
    // Takes [0-99] and turns it into ["zero"-"ninety-nine"] (no negatives)
    if (__uniwords_to_cardinal_map.count() == 0)
        __uniwords_to_cardinal_map = split_string("zero,one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen", ",");
    
    string result;
    if (is_following_digits_of_larger_number)
        result = "and ";
    
    int v = value % 100;
    
    if (v < 20)
        return result + __uniwords_to_cardinal_map[v];
    
    if (__tens_to_cardinal_map.count() == 0)
        __tens_to_cardinal_map = {2:"twenty", 3:"thirty", 4:"forty", 5:"fifty", 6:"sixty", 7:"seventy", 8:"eighty", 9:"ninety"};
    
    int tens = v / 10;
    result += __tens_to_cardinal_map[tens];
    
    int units = v % 10;
    if (units != 0)
        return result + "-" + __uniwords_to_cardinal_map[units];
    return result;
}
string tens_to_cardinal(int value)
{
    return tens_to_cardinal(value, false);
}

string hundreds_to_cardinal(int value, boolean is_following_digits_of_larger_number)
{
    // Takes [0-999] and turns it into ["zero"-"nine hundred ninety-nine"] (no negatives)
    int v = value % 1000;
    
    int hundreds = v / 100;
    if (hundreds == 0)
        return tens_to_cardinal(v, is_following_digits_of_larger_number); /* five million "and three" */
    
    string result = tens_to_cardinal(hundreds, false) + " hundred";
    
    int rest = v % 100;
    if (rest > 0)
        return result + " " + tens_to_cardinal(rest, is_following_digits_of_larger_number);
    return result;
}
string hundreds_to_cardinal(int value)
{
    return hundreds_to_cardinal(value, false);
}

static string [int] __short_scale_thousands_to_cardinal_map;
string int_to_cardinal(int v)
{
    string result;
    if (v < 0) {
        v = 0 - v;
        result += "minus";
    }
    
    if (__short_scale_thousands_to_cardinal_map.count() == 0)
        __short_scale_thousands_to_cardinal_map = {0:"",3:" thousand",6:" million",9:" billion"};
    
    int magnitude = v.length() - 1;
    int order_of_magnitude = magnitude - magnitude % 3;
    int rest = v;
    boolean start = true;
    
    while (order_of_magnitude >= 0) {
        int current_magnitude = 10**order_of_magnitude;
        
        int v_in_current_magnitude = rest / current_magnitude;
        
        if (v_in_current_magnitude > 0)
            result += " " + hundreds_to_cardinal(v_in_current_magnitude, !start) + __short_scale_thousands_to_cardinal_map[order_of_magnitude];

        order_of_magnitude -= 3;
        start = false;
    }
    return result;
}
string int_to_wordy(int v)
{
    return int_to_cardinal(v);
}

string int_to_position(int v)
{
    if (v == 0)
        return "-";
    
    string result = v;
    if (v < 0)
        v = 0 - v;
    
    if (v / 10 % 10 == 1)
        return result + "th";
    
    switch (v % 10) {
        case 1:
            return result + "st";
        case 2:
            return result + "nd";
        case 3:
            return result + "rd";
    }
    return result + "th";
}

string int_to_ordinal(int v)
{
    string cardinal = int_to_cardinal(v);
    if (cardinal.stringHasSuffix("y"))
        return cardinal.substring(0, cardinal.length() - 1) + "ieth";
    if (cardinal.stringHasSuffix("one"))
        return cardinal.substring(0, cardinal.length() - 3) + "first";
    if (cardinal.stringHasSuffix("two"))
        return cardinal.substring(0, cardinal.length() - 3) + "second";
    if (cardinal.stringHasSuffix("three"))
        return cardinal.substring(0, cardinal.length() - 3) + "ird";
    if (cardinal.stringHasSuffix("five"))
        return cardinal.substring(0, cardinal.length() - 2) + "fth";
    if (cardinal.stringHasSuffix("eight"))
        return cardinal + "h";
    if (cardinal.stringHasSuffix("nine"))
        return cardinal.substring(0, cardinal.length() - 1) + "th";
    if (cardinal.stringHasSuffix("twelve"))
        return cardinal.substring(0, cardinal.length() - 2) + "fth";
    return cardinal + "th";
}
string int_to_position_wordy(int v)
{
    return int_to_ordinal(v);
}


string capitaliseFirstLetter(string v)
{
	buffer buf = v.to_buffer();
	if (v.length() <= 0)
		return v;
	buf.replace(0, 1, buf.char_at(0).to_upper_case());
	return buf.to_string();
}

//shadowing; this may override ints
string pluralise(float value, string non_plural, string plural)
{
	string value_out = "";
	if (value.to_int() == value)
		value_out = value.to_int();
    else
    	value_out = value;
	if (value == 1.0)
		return value_out + " " + non_plural;
	else
		return value_out + " " + plural;
}

string pluralise(int value, string non_plural, string plural)
{
	if (value == 1)
		return value + " " + non_plural;
	else
		return value + " " + plural;
}

string pluralise(int value, item i)
{
	return pluralise(value, i.to_string(), i.plural);
}

string pluralise(item i) //whatever we have around
{
	return pluralise(i.available_amount(), i);
}

string pluralise(effect e)
{
    return pluralise(e.have_effect(), "turn", "turns") + " of " + e;
}

string pluraliseWordy(int value, string non_plural, string plural)
{
	if (value == 1)
    {
        if (non_plural == "more time") //we're gonna celebrate
            return "One More Time";
        else if (non_plural == "more turn")
            return "One More Turn";
		return value.int_to_wordy() + " " + non_plural;
    }
	else
		return value.int_to_wordy() + " " + plural;
}

string pluraliseWordy(int value, item i)
{
	return pluraliseWordy(value, i.to_string(), i.plural);
}

string pluraliseWordy(item i) //whatever we have around
{
	return pluraliseWordy(i.available_amount(), i);
}

string invSearch(string it)
{
    string url = "inventory.php?ftext=";
    url += it.replace_string(" ", "+");
    return url;
}

string invSearch(item it)
{
    return invSearch(it.name);
}


//Additions to standard API:
//Auto-conversion property functions:
boolean get_property_boolean(string property)
{
	return get_property(property).to_boolean();
}

int get_property_int(string property)
{
	return get_property(property).to_int_silent();
}

location get_property_location(string property)
{
	return get_property(property).to_location();
}

float get_property_float(string property)
{
	return get_property(property).to_float();
}

monster get_property_monster(string property)
{
	return get_property(property).to_monster();
}

//Returns true if the propery is equal to my_ascensions(). Commonly used in mafia properties.
boolean get_property_ascension(string property)
{
    return get_property_int(property) == my_ascensions();
}

element get_property_element(string property)
{
    return get_property(property).to_element();
}

item get_property_item(string property)
{
    return get_property(property).to_item();
}
