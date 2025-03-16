extends Node3D

@onready var dice = $Dice
@onready var camera = $Camera3D
@onready var selected_die = $Dice/Die
@onready var farkle = $Farkle
@onready var roll_button = $UI/RollButton


func _process(_delta: float) -> void:
	handleSelection()
	pass
		
		
func handleSelection():
	var new_selection = Global.get_object_at_cursor(self.get_world_3d(), camera)
	if(new_selection != selected_die):	
		if(is_die(selected_die)):
			selected_die.mouse_exit()
		if(is_die(new_selection)):
			new_selection.mouse_enter()
	selected_die = new_selection



###### HELPERS ######
		
func is_die(object):
	if object:
		if object.is_class("RigidBody3D"):
			if object.is_in_group("Die"):
				return true
	return false



###### EVENTS ######

func _on_roll_button_pressed() -> void:
	dice.roll_all()

func _on_dice_roll_finished(_dice : Array) -> void:
	#roll_button.visible = true
	pass

func _on_dice_roll_started() -> void:
	print("_on_dice_roll_started")
	roll_button.visible = false

func _on_dice_selected() -> void:
	print("die selected, evaluate...")
	var tmp_score = farkle.evaluate_selected()
	print(str("die selected, evaluate... ",tmp_score))
	$UI/ScorePanel/VBoxContainer/RoundScore.text = str(tmp_score)
