@tool

extends Node2D
class_name CharacterPortraitShower

@export var faction: Character.Faction :
	set(f): faction = f; _refresh()

@onready var friend: Sprite2D = $Friend
@onready var enemy: Sprite2D = $Enemy

func _ready():
	_refresh()

func _refresh():
	if friend == null: return
	friend.visible = faction == Character.Faction.GOOD
	enemy.visible = faction == Character.Faction.EVIL
