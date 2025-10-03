extends Node2D
class_name CharacterStatsShower

@onready var stats: Label = $Control/Stats

func set_character(s_character):
	stats.text = get_stats_text(s_character)

static func get_stats_text(s_character):
	var out = ""
	out += "HP:  " + str(Character.get_health(s_character)) + " / " + str(Character.get_max_health(s_character)) + "\n"
	out += "STR: " + str(Character.get_strength(s_character)) + "\n"
	out += "SPD: " + str(Character.get_speed(s_character)) + "\n"
	out += "MAG DEF: " + str(Character.get_magic_defense(s_character)) + "\n"
	return out
