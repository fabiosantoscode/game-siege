extends StatusEffect
class_name SlowdownEffect

@export var slowdown_duration = 0.5

func on_ready(_character: Character): pass

func on_after_physics_process(character: Character, delta: float):
	if slowdown_duration > 0.0001:
		slowdown_duration -= delta
		if character.velocity.length_squared() > 0.001:
			character.add_velocity(character.velocity * -0.8, delta)
	else:
		self.get_parent().remove_child(self)
		self.queue_free()

static func inflict_slowdown(on_character: Character):
	const SLOWDOWN_EFFECT = preload("res://status_effects/slowdown_effect.tscn")
	var slowdown: SlowdownEffect = SLOWDOWN_EFFECT.instantiate()
	on_character.add_child(slowdown)
