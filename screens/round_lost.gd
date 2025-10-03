extends Control

@onready var try_again_button: Button = $VBoxContainer/TryAgainButton

func _ready() -> void:
	try_again_button.pressed.connect(func():
		var assemblage: Assemblage = $".."
		assemblage.on_try_again()
		)
