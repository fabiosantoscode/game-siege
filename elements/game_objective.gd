extends Control

@onready var night_indicator_template: NinePatchRect = $NightIndicators/NightIndicatorTemplate
@onready var round_indicator_template: NinePatchRect = $NightIndicators/RoundIndicatorTemplate
@onready var night_indicators: Control = $NightIndicators

func _ready() -> void:
	night_indicators.remove_child(round_indicator_template)
	night_indicators.remove_child(night_indicator_template)

	for night_number in range(Balance.game_goal_night_count):
		var ind = night_indicator_template.duplicate()
		night_indicators.add_child(ind)
		ind.owner = self.owner
		ind.position.x = night_pos(night_number)
		for round_number in range(Balance.game_goal_rounds_per_night):
			var rind = round_indicator_template.duplicate()
			night_indicators.add_child(rind)
			rind.owner = self.owner
			rind.position.x = round_pos(night_number, round_number)

func night_pos(night_number):
	var me = night_number + 1
	var total = Balance.game_goal_night_count
	return (float(me) / float(total)) * night_indicators.size.x

func round_pos(night_number, round_number):
	var start = night_pos(night_number - 1)
	var end = night_pos(night_number)
	var me = round_number + 1
	var total = Balance.game_goal_rounds_per_night + 1
	return start + (float(me) / float(total)) * (end - start)
