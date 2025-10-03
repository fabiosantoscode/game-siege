extends BasePickup
class_name PickupRaiseMagicDefense

func apply_pickup():
	for_each_troops(func (member):
		member["magic_defense"] = ceili(float(member["magic_defense"]) * Balance.stat_progression_magic_defense)
	)

func get_pickup_name():
	return "raise speed"
