extends Object
class_name BasePickup

# copy as follows
# extends BasePickup
# class_name XXXXPickup

func apply_pickup():
	assert(false, "implement apply_pickup()")

func get_pickup_name():
	assert(false, "implement get_pickup_name()")

static var all_pickups = [
	PickupHeal,
	PickupNewUnit,
	PickupRaiseHealth,
	PickupRaiseStrength,
	PickupHammer,
	PickupMagic,
]

static func create_random_pickups(count: int):
	assert(count < len(all_pickups))
	var randomized = all_pickups.duplicate()
	randomized.shuffle()
	return randomized.slice(0, count).map(func (pi): return pi.new())

# Library functions
func give_bit_to_random_troop(s_bit):
	var member = _find_troop_or_random(func (troop):
		return not troop["bits"].has(s_bit))
	member["bits"].push_front(s_bit)

func _find_troop_or_random(finder: Callable):
	var members = GlobalState.troops.duplicate()
	members.shuffle()
	for s_character in members:
		if finder.call(s_character):
			return s_character
	return members.pick_random()

func for_each_troops(cb: Callable):
	var members = GlobalState.troops.duplicate()
	members.shuffle()
	for s_character in members:
		cb.call(s_character)

func mut_random_troop(cb: Callable):
	cb.call(GlobalState.troops.pick_random())

func add_to_party(s_troop):
	GlobalState.troops.push_back(s_troop)
