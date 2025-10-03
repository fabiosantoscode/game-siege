extends Node2D
class_name BitsMagicProjectile

@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var visual: Node = $Visual
@onready var damage_area: Area2D = $DamageArea
var initial_position = Vector2.INF

var speed = 300.0
var lifetime = 6.0
@export var my_character: Character
const BITS_MAGIC_PROJECTILE = preload("res://character_bits/bits_magic_projectile.tscn")

static func spawn_projectile(character: Character, towards: Character, pos):
	var new_self = Utils.spawn(character.owner, BITS_MAGIC_PROJECTILE, pos)
	new_self.my_character = character
	new_self.rotation = pos.angle_to_point(towards.global_position)
	new_self.initial_position = pos
	return new_self

func _physics_process(delta: float):
	self.position += (Vector2.RIGHT * speed * delta).rotated(self.rotation)
	self.lifetime -= delta
	if self.lifetime < 0 or my_character == null:
		self.queue_free()

func _on_damage(body: Node2D):
	if body is Character and my_character != null and my_character.is_enemy_of(body):
		var c: Character = body
		KnockbackEffect.inflict_knockback(initial_position, c, 0.2)
		
		var damage = Balance.weapon_magic_damage
		damage *= my_character.strength
		damage /= c.magic_defense
		c.inflict_damage(roundi(damage))

func _ready():
	animation_player.play("idle")
	damage_area.body_entered.connect(_on_damage)
