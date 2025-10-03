extends CharacterBit
class_name BitsMagic

@onready var spell_spawn: Node2D = $AnimatedSprite2D/SpellSpawn

@onready var spell_wait_time_min = Balance.weapon_magic_wait_time * 0.8
@onready var spell_wait_time_max = Balance.weapon_magic_wait_time * 1.2

@onready var channeling_time_min = Balance.weapon_magic_channeling_time * 0.8
@onready var channeling_time_max = Balance.weapon_magic_channeling_time * 1.2

func ask_leg_goal():
	if state["state"] == "channeling":
		return BitsLeg.LegGoal.STOP
	else:
		return BitsLeg.LegGoal.FAR_FROM_ENEMY

func get_bit_name(): return "Magic"

func get_portrait(): return preload("res://character_bits/bits_magic_portrait.tscn")

func on_ready(_character: Character): pass

# State machine
var state = { "state": "START" }
func on_physics_process(character: Character, delta: float):
	var closest_enemy = character.enemies[0] if len(character.enemies) else null
	var wait_time_ended = Utils.decrement_wait(state, delta)

	if not closest_enemy:
		state = { "state": "START" }

	elif state["state"] == "START":
		state = { "state": "targeting", "wait": randf_range(spell_wait_time_min, spell_wait_time_max) }

	elif state["state"] == "targeting":
		if wait_time_ended:
			state = { "state": "channeling", "wait": randf_range(channeling_time_min, channeling_time_max) }

	elif state["state"] == "channeling":
		if wait_time_ended:
			BitsMagicProjectile.spawn_projectile(character, closest_enemy, spell_spawn.global_position)
			state = { "state": "START" }
