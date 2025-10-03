extends BasePickup
class_name PickupRaiseHealth

func apply_pickup():
	for_each_troops(func (member):
		member["max_health"] = ceil(float(member["max_health"]) * Balance.stat_progression_health)
		if member["health"] < member["max_health"]:
			member["health"] = member["max_health"]
	)

func get_pickup_name():
	return "raise health"
