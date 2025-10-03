extends Control

@onready var button_1: Button = $VBoxContainer/HBoxContainer/Button1
@onready var button_2: Button = $VBoxContainer/HBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/HBoxContainer/Button3

func _ready():
	var options = BasePickup.create_random_pickups(3)
	for button in [button_1, button_2, button_3]:
		var option = options.pop_back()
		button.text = option.get_pickup_name()
		button.pressed.connect(func():
			var assemblage: Assemblage = $".."
			assemblage.on_between_rounds_end(option)
		)
