extends Node2D

@onready var character_stats_shower_template: CharacterStatsShower = $CharacterStatsShower
@onready var character_bits_shower_template: CharacterBitsShower = $CharacterBitsShower
@onready var template: Node2D = $Template

func _ready() -> void:
	self.remove_child(template)
	self.remove_child(character_bits_shower_template)

	for s_troop in GlobalState.troops:
		var pos = s_troop['coordinates']

		var char_ = Utils.spawn(self, template.duplicate(), pos)

		var character_bits_shower = Utils.spawn(self, character_bits_shower_template.duplicate(), pos)
		character_bits_shower.character_bits = s_troop['bits']

		var character_stats_shower = Utils.spawn(self, character_stats_shower_template.duplicate(), pos)
		character_stats_shower.set_character(s_troop)
