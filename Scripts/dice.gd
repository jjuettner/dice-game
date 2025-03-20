extends Node3D

@onready var dice = get_children()
@onready var label_total : Label = $"../UI/RollTotalLabel"
@onready var label_values : Label = $"../UI/RollValuesLabel"
@onready var roll_button : Button = $"../UI/RollButton"
@onready var commit_button : Button = $"../UI/CommitButton"

var rolling = true
var wait_for_score = true
var is_ready = true
var total_value = 0
var values = []

signal roll_finished(dice: Array)
signal roll_started()
signal selected()


func _ready() -> void:
	for die in get_children():
		die.connect("selected",Callable(self,"die_selected"))

func _process(_delta: float) -> void:
	if wait_for_score and not is_rolling():
		on_roll_finished()
		update_labels()

func on_roll_finished():
	total_value = 0
	values = []
	for die in dice:
		if not die.is_locked:
			values.append(die.value)
			total_value += die.value
	values.sort()
	wait_for_score = false
	roll_finished.emit(dice)


func update_labels():
	label_total.text = str(Global.LABEL_ROLL_TOTAL,total_value)
	label_values.text = str(values)
	
func is_rolling():
	for die in dice:
		if die.value == 0:
			return true
	return false

func roll_all():
	for die in dice:
		if not die.is_selected:
			die.roll()
	wait_for_score = true
	roll_started.emit()
	label_total.text = str(Global.LABEL_ROLL_TOTAL,"??")
	var empty_values_string = str(values.map(func(_x): return "?"))
	empty_values_string = empty_values_string.replace('"','')
	label_values.text = empty_values_string

func reset():
	for die in dice:
		die.reset()
	roll_button.visible = true

##### EVENTS #####

func die_selected(_die):
	selected.emit()


func _on_roll_button_pressed() -> void:
	roll_all()
	roll_button.visible = false
