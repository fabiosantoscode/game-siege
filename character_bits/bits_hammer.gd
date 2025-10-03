extends CharacterBit
class_name BitsHammer

var attack_distance = 34.0 ** 2
var time_between_attacks = 1.0 / Balance.weapon_hammer_attack_rate
var random_attack_delay = 0.6
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hammer: Node2D = $Hammer
@onready var damage_area: Area2D = $Hammer/HammerHandle/Damage
@onready var my_character: Character = $".."

func ask_leg_goal(): return BitsLeg.LegGoal.CLOSE_TO_ENEMY

func get_bit_name(): return "Hammer"

func get_portrait(): return preload("res://character_bits/bits_hammer_portrait.tscn")

func on_ready(_character: Character):
	damage_area.body_entered.connect(on_damage_hit)

func on_damage_hit(enemy: Node):
	if enemy is Character and my_character.is_enemy_of(enemy):
		enemy.inflict_damage(Balance.weapon_hammer_damage * my_character.strength)
		KnockbackEffect.inflict_knockback(self.global_position, enemy)

## free-form state machine. attack when close, wait between attacks
var state = { "state": "START" }
func on_physics_process(character: Character, delta: float):
	var wait_time_ended = Utils.decrement_wait(state, delta)

	if state["state"] == "START":
		var me = character.global_position
		var enemy = character.enemies[0].global_position if len(character.enemies) else Vector2.ZERO

		# when enemy is close
		if enemy != Vector2.ZERO and enemy.distance_squared_to(me) <= attack_distance:
			state = { "state": "pre_attacking", "wait": random_attack_delay * randf_range(0.0, 1.0) }

	elif state["state"] == "pre_attacking":
		if character.enemies.is_empty():
			state = { "state": "START" }
			return

		elif wait_time_ended:
			var enemy = character.enemies[0].global_position
			var me = character.global_position
			var enemy_angle = (enemy - me).angle()
			self.rotation = enemy_angle + TAU / 4.0
			animation_player.play("attack")
			state = { "state": "attacking" }

	elif state["state"] == "attacking":
		if not animation_player.is_playing():
			state = { "state": "wait_after_attack", "wait": time_between_attacks }

	elif state["state"] == "wait_after_attack":
		if wait_time_ended:
			state = { "state": "START" }
