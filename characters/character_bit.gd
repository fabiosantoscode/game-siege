extends Node2D
class_name CharacterBit

func get_bit_name(): assert(false, "TODO return string here")
func get_portrait(): assert(false, "TODO return portrait PackedScene")
func on_ready(_character: Character): pass
func on_physics_process(_character: Character, _delta: float): pass

static var s_randomly_spawnable_bits = ["bits_hammer", "bits_magic"]

static func create_random_bits(bits_count):
	var out = []
	for _i in range(bits_count):
		out.push_back(s_randomly_spawnable_bits.pick_random())
	return out

static func serialize_bit(bit: CharacterBit):
	if bit is BitsHammer: return "bits_hammer"
	if bit is BitsMagic: return "bits_magic"
	assert(false)

static func get_bit_by_name(s_bit):
	match s_bit:
		"bits_hammer": return preload("res://character_bits/bits_hammer.tscn")
		"bits_magic": return preload("res://character_bits/bits_magic.tscn")

static func deserialize_bit(s_bit, character: Character):
	var bit = get_bit_by_name(s_bit)
	assert(bit)

	character.add_child(bit.instantiate())
