extends CharacterBit
class_name BitsLeg

var erratic_movement_limit = 24.0
var speed = 15.0
var erratic_speed = 5.0

@onready var distances = {
	LegGoal.FAR_FROM_ENEMY: 64.0,
	LegGoal.CLOSE_TO_ENEMY: 18.0,
}

## Largest items in the enum take priority
enum LegGoal { FAR_FROM_ENEMY, CLOSE_TO_ENEMY, STOP }

func get_bit_name(): return "Legs"

var was_erratic_before = false
func on_physics_process(character: Character, delta: float):
	# Move towards closest enemy (character.enemies[0])
	if len(character.enemies) > 0:
		was_erratic_before = false

		var goal: LegGoal = LegGoal.FAR_FROM_ENEMY
		for bit in character.bits:
			if bit.has_method("ask_leg_goal"):
				var here_goal = bit.ask_leg_goal()
				if here_goal > goal:
					goal = here_goal

		if goal == LegGoal.STOP:
			return

		var towards_enemy = character.enemies[0].global_position - character.global_position
		var desired_dist = distances[goal]
		var actual_dist = towards_enemy.length()
		var direction = towards_enemy if desired_dist < actual_dist else -towards_enemy

		character.add_velocity(direction.normalized() * speed, delta)
	else:
		if not was_erratic_before:
			was_erratic_before = true
			erratic_home = character.global_position

		erratic_movement(character, delta)

var erratic_home = Vector2.ZERO
var erratic_data = {} # like a state machine
func erratic_movement(character: Character, delta):
	if erratic_data.is_empty():
		erratic_data = { "delay": randf_range(0.6, 1.2) ** 2 }

	if erratic_data.has("delay"):
		var new_delay = erratic_data["delay"] - delta
		if new_delay > 0:
			erratic_data["delay"] = new_delay
		else:
			var distance = (erratic_movement_limit if randi_range(0, 4) else 4.0) * randf_range(0.6, 1.0) ** 2
			var rand_rot = randf_range(0, TAU)
			var rand_vec = Vector2.UP.rotated(rand_rot) * distance
			erratic_data = { "move": erratic_home + rand_vec }

	if erratic_data.has("move"):
		character.move_within_x_pixels_of_target(erratic_data["move"], 4.0, erratic_speed, delta)

func on_ready(character: Character):
	erratic_home = character.global_position
