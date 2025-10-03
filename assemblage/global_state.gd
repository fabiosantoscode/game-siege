extends Node
class_name GlobalState_

const CHARACTER = preload("res://characters/character.tscn")

## level: determines difficulty
var current_level = 1

## our troops
var troops = []
## user-specified coordinates
var troops_coordinates: Array[Vector2]:
	get: return troops.map(func (s_troop): s_troop["coordinates"])
	set(cx): for i in range(len(cx)): troops[i]["coordinates"] = cx[i]

var enemy_troops = []

func reset_game():
	current_level = 1
	troops = []
	enemy_troops = []
	enemy_troops = []
	# create friends and enemies (initial)
	create_characters(3, 1, Character.Faction.GOOD)
	create_enemies(1)

func _ready():
	reset_game()

func go_to_next_level():
	current_level += 1
	create_enemies(1)
	for troop in troops:
		if troop["health"] < troop["max_health"]:
			troop["health"] = mini(troop["health"] + 4, troop["max_health"])
		troop["before_clamp_coordinates"] = troop["coordinates"]
		troop["coordinates"] = SpawnAreas.clamp_coords_to_spawn_rect(troop["coordinates"], troop["faction"])

func create_enemies(round_num):
	var enemy_troops_count = round_num
	var equipment_bits_count = maxi(1, floor(log(round_num)))
	create_characters(enemy_troops_count, round_num, Character.Faction.EVIL)

func create_characters(char_count: int, bits_count: int, faction: Character.Faction):
	for char_i in range(char_count):
		var s_chara = Character.create_random_character(
			bits_count,
			SpawnAreas.random_spawn_coordinate(faction),
			faction
		)

		match faction:
			Character.Faction.EVIL: enemy_troops.push_back(s_chara)
			Character.Faction.GOOD: troops.push_back(s_chara)
			_: assert(false)
