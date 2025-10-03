extends Node2D
class_name SpawnAreas_

@onready var friend_spawn_rect: Rect2 = $FriendSpawns/Rect.get_global_rect()
@onready var enemy_spawn_rect: Rect2 = $EnemySpawns/Rect.get_global_rect()

func random_spawn_coordinate(faction: Character.Faction):
	var rect = spawn_rect(faction)
	return rect.position + Vector2(randf(), randf()) * rect.size

func clamp_coords_to_spawn_rect(coords: Vector2, faction: Character.Faction):
	var rect = spawn_rect(faction)
	var top_left = rect.position
	var bot_right = rect.position + rect.size

	return coords.clamp(top_left, bot_right)

func spawn_rect(faction: Character.Faction):
	match faction:
		Character.Faction.GOOD: return friend_spawn_rect
		Character.Faction.EVIL: return enemy_spawn_rect
		_: assert(false)
