extends Node
class_name Assemblage

const SCREEN_TITLE = preload("res://screens/title_screen.tscn")
const SCREEN_ROUND = preload("res://screens/round.tscn")
const SCREEN_YOU_LOST = preload("res://screens/round_lost.tscn")
const SCREEN_PICK_UPS = preload("res://screens/between_rounds.tscn")
const SCREEN_PLACE_TROOPS = preload("res://screens/troop_placement.tscn")

func _ready():
	# Go straight to the meat of the game
	if OS.has_feature("dev") and false: _swap(SCREEN_ROUND, true)
	else: _swap(SCREEN_TITLE, true)

func on_title_screen_end():
	_swap.call_deferred(SCREEN_PICK_UPS)

func on_between_rounds_end(pickup: BasePickup):
	pickup.apply_pickup()
	_swap.call_deferred(SCREEN_PLACE_TROOPS)

func on_troop_placement_end(troops_coordinates: Array[Vector2]):
	GlobalState.troops_coordinates = troops_coordinates
	_swap.call_deferred(SCREEN_ROUND)

func on_round_end(win: bool):
	if win:
		GlobalState.go_to_next_level()
		_swap.call_deferred(SCREEN_PICK_UPS)
	else:
		GlobalState.reset_game()
		_swap.call_deferred(SCREEN_YOU_LOST)

func on_try_again():
	_swap.call_deferred(SCREEN_TITLE)

func _swap(scene: PackedScene, is_first=false):
	Utils.clear_children(self)

	var node = scene.instantiate()
	if node is Control:
		# I am Assemblage, not a Control. We need to add size to children
		node.size = Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height"))
	self.add_child(node)
