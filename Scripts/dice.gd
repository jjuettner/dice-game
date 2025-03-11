extends Node3D

@onready var dice = get_children()
@onready var label_total : Label = $"../UI/RollTotalLabel"
@onready var label_values : Label = $"../UI/RollValuesLabel"

var rolling = true
var wait_for_score = true
var total_value = 0
var values = []

func _process(_delta: float) -> void:	
	if wait_for_score and not is_rolling():
		total_value = 0
		values = []
		for die in dice:
			values.append(die.value)
			total_value += die.value
		label_total.text = str(Global.LABEL_ROLL_TOTAL,total_value)
		values.sort()
		label_values.text = str(values)
		wait_for_score = false
	
func is_rolling():
	for die in dice:
		if die.value == 0:
			return true
	return false
		

func roll_all():
	for die in dice:
		die.roll()
	wait_for_score = true
	label_total.text = str(Global.LABEL_ROLL_TOTAL,"??")
	var empty_values_string = str(values.map(func(x): return "?"))
	print(empty_values_string)
	empty_values_string = empty_values_string.replace('"','')
	print(empty_values_string)
	label_values.text = empty_values_string
