extends BasePickup
class_name PickupMagic

func apply_pickup():
	give_bit_to_random_troop("bits_magic")

func get_pickup_name():
	return "weapon: magic"
