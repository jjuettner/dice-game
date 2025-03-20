extends Node3D

var started = false
var selection_active = false
@onready var dice = $Dice
@onready var camera = $Camera3D
@onready var selected_die = $Dice/Die


func _process(_delta: float) -> void:
	if selection_active:
		handleSelection()
		
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


func _on_dice_roll_finished(_dice: Array) -> void:
	if started:
		selection_active = true
		print("selection active")


func _on_dice_roll_started() -> void:
	selection_active = false
	started = true
	print("selection inactive")


func _on_farkle_is_bust() -> void:
	selection_active = false
