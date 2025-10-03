extends Node2D

@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var friend_spawner: Node2D = $FriendSpawner

func _ready():
	await _spawn_characters()
	var did_win = await _poll_end_state()
	if did_win: _despawn_characters()

	var assemblage: Assemblage = $".."
	assemblage.on_round_end(did_win)

func _poll_end_state():
	while true:
		await get_tree().create_timer(0.5).timeout
		var good_chars = 0
		var evil_chars = 0

		for char in self.find_children("*", "Character", true, false):
			if char.faction == Character.Faction.GOOD: good_chars += 1
			if char.faction == Character.Faction.EVIL: evil_chars += 1

		if good_chars == 0 or evil_chars == 0:
			return evil_chars == 0

func _spawn_characters():
	for i in range(len(GlobalState.enemy_troops)):
		var s_troop = GlobalState.enemy_troops[i]
		await Character.deserialize(s_troop, enemy_spawner)

	for i in range(len(GlobalState.troops)):
		var s_troop = GlobalState.troops[i]
		await Character.deserialize(s_troop, friend_spawner)

func _despawn_characters():
	var troops = []
	for char: Character in self.find_children("*", "Character", true, false):
		assert(char.faction == Character.Faction.GOOD)
		troops.push_back(Character.serialize(char))
	GlobalState.troops = troops
