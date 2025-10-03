extends RefCounted
class_name Balance

# Game goal
static var game_goal_night_count = 7
static var game_goal_rounds_per_night = 3

# weapon stats
static var weapon_hammer_damage = 4.0
static var weapon_hammer_attack_rate = 1.8#attacks per second
static var weapon_magic_damage = 1.0
static var weapon_magic_wait_time = 0.5#seconds between attacks
static var weapon_magic_channeling_time = 0.8#seconds needed to channel

# Stat bases
static var stat_base_max_health: int = 10
static var stat_base_magic_defense = 1.0 #divider
static var stat_base_strength = 1.0 #multiplier
static var stat_base_speed = 1.0 #multiplier

# Stat progression (multipliers)
static var stat_progression_health = 2.0
static var stat_progression_magic_defense = 2.0
static var stat_progression_strength = 2.0
static var stat_progression_speed = 2.0
