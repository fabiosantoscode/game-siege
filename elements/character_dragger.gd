extends Node2D
class_name CharacterDragger

const CHARACTER_DRAGGER = preload("res://elements/character_dragger.tscn")

const half_size = 16.0
@export var drag_limiter: Rect2 = Rect2(0, 0, 0, 0)
@onready var button: TextureButton = $Button
@onready var character_bits_shower: Node2D = $CharacterBitsShower
@onready var character_stats_shower: CharacterStatsShower = $CharacterStatsShower

static func spawn_dragger(parent: Node, s_troop) -> CharacterDragger:
	var coordinates: Vector2 = Character.get_coordinates(s_troop)
	var new_self = Utils.spawn(parent, CHARACTER_DRAGGER, coordinates)
	new_self.character_bits_shower.character_bits = Character.get_bits(s_troop)
	new_self.character_stats_shower.set_character(s_troop)
	return new_self

func _ready() -> void:
	button.button_down.connect(_drag_start)
	button.button_up.connect(_drag_end)
	get_window().mouse_exited.connect(_drag_end)

var _dragging = false
var _drag_pos = Vector2.ZERO

func _drag_start():
	_drag_pos = _mouse_pos() - self.global_position
	_dragging = true

func _process(_delta):
	if _dragging:
		var next_pos = _mouse_pos() - _drag_pos
		next_pos = SpawnAreas.clamp_coords_to_spawn_rect(next_pos, Character.Faction.GOOD)
		self.global_position = next_pos

func _drag_end():
	_drag_pos = Vector2.ZERO
	_dragging = false

func _mouse_pos():
	return get_global_mouse_position()
