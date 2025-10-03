extends CharacterBody2D
class_name Character

const CHARACTER_SCENE = preload("res://characters/character.tscn")

enum Faction { NEUTRAL, GOOD, EVIL }

@export var age_days = 0
var max_health: int
var health: int
var strength: float
var magic_defense: float
var speed: float
@export var faction: Faction = Faction.NEUTRAL

@onready var visuals: CharacterPortraitShower = $Visuals
@onready var size_radius = $CollisionShape2D.shape.radius
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var enemies: Array[Character] = []
var bits: Array[CharacterBit] = []
var status_effects: Array[StatusEffect] = []

func _ready():
	recompute_enemies()
	visuals.faction = faction

	for child in self.get_children():
		self.on_child_entered_tree(child)

	self.child_entered_tree.connect(self.on_child_entered_tree)
	self.child_exiting_tree.connect(self.on_child_exiting_tree)

func _physics_process(delta: float) -> void:
	self.velocity = Vector2.ZERO
	recompute_enemies()

	for bit in status_effects:
		bit.on_physics_process(self, delta)

	for bit in bits:
		bit.on_physics_process(self, delta)

	for bit in status_effects:
		bit.on_after_physics_process(self, delta)

	self.move_and_slide()

func recompute_enemies():
	self.enemies = []
	if self.faction == Faction.NEUTRAL: return

	for other in get_tree().root.find_children("", "Character", true, false):
		if self.is_enemy_of(other):
			self.enemies.push_back(other)

	var my_pos = self.global_position
	self.enemies.sort_custom(func(a, b):
		var a_dist = a.global_position.distance_squared_to(my_pos)
		var b_dist = b.global_position.distance_squared_to(my_pos)
		return a_dist < b_dist)

static func get_coordinates(s_char) -> Vector2: return s_char["coordinates"]
static func get_bits(s_char) -> Array: return s_char["bits"]
static func get_health(s_char) -> int: return s_char["health"]
static func get_max_health(s_char) -> int: return s_char["max_health"]
static func get_strength(s_char) -> float: return s_char["strength"]
static func get_magic_defense(s_char) -> float: return s_char["magic_defense"]
static func get_speed(s_char) -> float: return s_char["speed"]

##### DAMAGE SYSTEM ######

func inflict_damage(health_reduction: int):
	self.health -= health_reduction
	animation_player.play("damage")
	if self.health <= 0:
		await get_tree().create_timer(0.4).timeout
		self.queue_free()

##### FACTION SYSTEM #####

func is_enemy_of(other: Character):
	return (other.faction != self.faction
		and self.faction != Faction.NEUTRAL and other.faction != Faction.NEUTRAL)


##### VELOCITY SYSTEM ######
## self.velocity is reset every frame, and status effects or body parts can add to it

## Makes character move (changes velocity) but stops if we collide
func add_velocity(vel: Vector2, delta: float) -> bool:
	var velocity_after = self.velocity + vel

	# restart if we'll collide with anything
	if self.test_move(self.global_transform, velocity_after * delta, null, 5.0):
		self.velocity = Vector2.ZERO
		return false
	else:
		self.velocity = velocity_after
		return true

## Makes character move (changes velocity) towards a target, but stops when within X pixels
func move_within_x_pixels_of_target(target: Vector2, x: float, speed: float, delta: float) -> bool:
	var towards_target = target - self.global_position
	var velocity_after = self.velocity + towards_target.normalized() * speed

	# restart if we'll collide with anything or close to getting there
	if (self.test_move(self.global_transform, velocity_after * delta, null, 5.0)
		or towards_target.length() < x):
		return false
	else:
		self.velocity = velocity_after
		return true

###### Components system ######
## "CharacterBit" and "StatusEffect" can be added as children of this thing

func on_child_entered_tree(child: Node):
	if child is CharacterBit:
		bits.push_back(child)
		child.on_ready(self)
	if child is StatusEffect:
		status_effects.push_back(child)
		child.on_ready(self)

func on_child_exiting_tree(child: Node):
	if child is CharacterBit:
		var idx = bits.find(child)
		assert(idx >= 0)
		bits.remove_at(idx)
	if child is StatusEffect:
		var idx = status_effects.find(child)
		assert(idx >= 0)
		status_effects.remove_at(idx)

static func deserialize(s_character: Dictionary, parent: Node2D):
	var character: Character = CHARACTER_SCENE.instantiate()
	character.faction = s_character["faction"]
	character.age_days = s_character["age_days"]
	character.position = s_character["coordinates"]
	character.health = s_character["health"]
	# stats
	character.max_health = s_character["max_health"]
	character.strength = s_character["strength"]
	character.magic_defense = s_character["magic_defense"]
	character.speed = s_character["speed"]
	Character.deserialize_bits(s_character["bits"], character)
	parent.add_child(character)
	character.owner = parent

static func serialize(character: Character):
	return {
		"faction": character.faction,
		"age_days": character.age_days,
		"coordinates": character.position,
		"max_health": character.max_health,
		"health": character.health,
		"magic_defense": character.magic_defense,
		"strength": character.strength,
		"speed": character.speed,
		"bits": Character.serialize_bits(character.find_children("*", "", true, false)),
	}

## Create a serialized character
static func create_random_character(bits_count, coordinates, faction):
	return {
		"faction": faction,
		"age_days": 0,
		"coordinates": coordinates,
		"max_health": Balance.stat_base_max_health,
		"health": Balance.stat_base_max_health,
		"magic_defense": Balance.stat_base_magic_defense,
		"strength": Balance.stat_base_strength,
		"speed": Balance.stat_base_speed,
		"bits": CharacterBit.create_random_bits(bits_count),
	}

## "serialize" bits by just removing them from the tree
static func serialize_bits(bits):
	var out = []
	for bit in bits:
		if is_instance_of(bit, CharacterBit):
			if not bit is BitsLeg:
				out.push_back(CharacterBit.serialize_bit(bit))
	return out

static func deserialize_bits(s_bits: Array, character: Character):
	for s_bit in s_bits:
		CharacterBit.deserialize_bit(s_bit, character)
