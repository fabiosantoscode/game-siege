extends Control

@onready var new_game_button: Button = $NewGameButton

func _ready() -> void:
	new_game_button.pressed.connect(func():
		var assemblage: Assemblage = $".."
		assemblage.on_title_screen_end()
		)
