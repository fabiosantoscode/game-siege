extends BasePickup
class_name PickupRaiseStrength

func apply_pickup():
	for_each_troops(func (member):
		if member["strength"] <= 2: member["strength"] += 1
		else: member["strength"] = ceili(float(member["strength"]) * Balance.stat_progression_strength)
	)

func get_pickup_name():
	return "raise ATK"
