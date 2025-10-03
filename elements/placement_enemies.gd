extends Node2D

@onready var character_bits_shower_template: CharacterBitsShower = $CharacterBitsShower
@onready var template: Node2D = $Template

func _ready() -> void:
	self.remove_child(template)
	self.remove_child(character_bits_shower_template)

	for s_enemy in GlobalState.enemy_troops:
		var enemy = Utils.spawn(self, template.duplicate(), s_enemy['coordinates'])
		var character_bits_shower = Utils.spawn(self, character_bits_shower_template.duplicate(), s_enemy['coordinates'])

		character_bits_shower.character_bits = s_enemy['bits']
