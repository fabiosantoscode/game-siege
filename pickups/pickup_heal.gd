extends BasePickup
class_name PickupHeal

func apply_pickup():
	for_each_troops(func (member):
		if member["health"] < member["max_health"]:
			member["health"] = member["max_health"]
	)

func get_pickup_name():
	return "heal clan"
