extends StatusEffect
class_name KnockbackEffect

@export var knockback_duration = 0.35
@export var knockback_angle = 0.0

func on_ready(_character: Character): pass

func on_physics_process(character: Character, delta: float):
	if knockback_duration > 0.0001:
		knockback_duration -= delta
		character.add_velocity(Vector2.from_angle(knockback_angle) * 60.0, delta)
	else:
		self.get_parent().remove_child(self)
		self.queue_free()

static func inflict_knockback(from_weapon: Vector2, on_character: Character, duration_mod = 1.0):
	const KNOCKBACK_EFFECT = preload("res://status_effects/knockback_effect.tscn")
	var knockback: KnockbackEffect = KNOCKBACK_EFFECT.instantiate()
	knockback.knockback_angle = from_weapon.angle_to_point(on_character.global_position)
	knockback.knockback_duration *= duration_mod
	on_character.add_child(knockback)
	knockback.owner = on_character
