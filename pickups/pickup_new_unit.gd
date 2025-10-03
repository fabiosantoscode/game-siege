extends BasePickup
class_name PickupNewUnit

func apply_pickup():
	add_to_party(Character.create_random_character(1, SpawnAreas.random_spawn_coordinate(Character.Faction.GOOD), Character.Faction.GOOD))

func get_pickup_name():
	return "new recruit"
