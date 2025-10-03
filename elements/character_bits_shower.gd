extends Node2D
class_name CharacterBitsShower

@export var character_bits: Array :
	set(bits): character_bits = bits; _add_portraits()

func _ready() -> void:
	_add_portraits()

func _add_portraits():
	Utils.clear_children(self)
	for bit_name in self.character_bits:
		var bit = CharacterBit.get_bit_by_name(bit_name).instantiate()
		var portrait = bit.get_portrait()
		Utils.spawn(self, portrait)
