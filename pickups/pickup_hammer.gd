extends BasePickup
class_name PickupHammer

func apply_pickup():
	give_bit_to_random_troop("bits_hammer")

func get_pickup_name():
	return "weapon: hammer"
