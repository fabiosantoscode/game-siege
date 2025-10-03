extends BasePickup
class_name PickupRaiseSpeed

var speed_progression = 1.5

func apply_pickup():
	for_each_troops(func (member):
		member["speed"] = ceili(float(member["speed"]) * Balance.stat_progression_speed)
	)

func get_pickup_name():
	return "raise magic DEF"
