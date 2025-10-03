extends Node2D

@onready var placement_enemies: Node2D = $PlacementEnemies
@onready var fight_button: Button = $CanvasLayer/FightButton

var troop_draggers: Array[CharacterDragger]

func _ready():
	fight_button.pressed.connect(_on_done)

	for troop in GlobalState.troops:
		var char = CharacterDragger.spawn_dragger(self, troop)
		char.drag_limiter = SpawnAreas.spawn_rect(Character.Faction.GOOD)
		troop_draggers.push_back(char)

func _on_done():
	var assemblage: Assemblage = $'..'
	assemblage.on_troop_placement_end(_get_coordinates())

func _get_coordinates():
	var troops: Array[Vector2] = []
	for troop in troop_draggers:
		troops.push_back(troop.global_position)
	return troops
