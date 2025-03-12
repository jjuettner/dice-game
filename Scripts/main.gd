extends Node3D

@onready var dice = $Dice
@onready var camera = $Camera3D
#@onready var die_scene : PackedScene = load("res://Scenes/die.tscn")
@onready var selected_die = $Dice/Die


func _process(delta: float) -> void:
	handleSelection()
	pass
		
		
func handleSelection():
	var new_selection = get_object_at_cursor()
	if(new_selection != selected_die):	
		if(is_die(selected_die)):
			selected_die.mouse_exit()
		if(is_die(new_selection)):
			new_selection.mouse_enter()
	selected_die = new_selection
		
func is_die(object):
	if object:
		if object.is_class("RigidBody3D"):
			if object.is_in_group("Die"):
				return true
	return false
	

func _on_roll_button_pressed() -> void:
	dice.roll_all()

#func show_selection_marker(die: RigidBody3D):
	#var marker = selection_marker.instantiate()  # Instantiate the scene
	#marker.global_transform.origin = die["position"]  # Place at hit position
	#add_child(marker)  # Add to scene

func get_object_at_cursor():
	var space_state = get_world_3d().direct_space_state  # Get the physics space
	var mouse_pos = get_viewport().get_mouse_position()  # Get mouse position
	var ray_origin = camera.project_ray_origin(mouse_pos)  # Convert to 3D position
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000  # Cast the ray far

	# Define raycast query
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true  # Enable area collision if needed

	var result = space_state.intersect_ray(query).collider  # Perform the raycast

	return result
		
