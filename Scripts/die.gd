extends RigidBody3D

@onready var raycasts = $Rays.get_children()
@onready var selection_marker : PackedScene = load("res://Scenes/selection_marker.tscn")
@onready var selection_material : StandardMaterial3D = load("res://Materials/marker_material.tres")
@onready var highlight_material : StandardMaterial3D = load("res://Materials/highlight_material.tres")
@onready var marker = $SelectionMarker


var throw_strength = 10
var spin_strength = .5
var rolling = false
var value: int
var is_selected : bool = false
var has_focus : bool = false

#signal roll_finished(value)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		handle_click()
	
func handle_click():
	if has_focus:
		is_selected = not is_selected
		update_marker_state()

func update_marker_state():
	if is_selected:
		marker.get_child(0).set_surface_override_material(0,selection_material)
	else:
		marker.get_child(0).set_surface_override_material(0,highlight_material)

func mouse_enter():
	has_focus = true
	marker.visible = true
	
	
func mouse_exit():
	has_focus = false
	if not is_selected:
		marker.visible = false

func roll():
	freeze = false
	rolling = true
	value = 0
	apply_impulse(random_up_vector(throw_strength))
	apply_torque_impulse(random_vector(spin_strength))
	
func random_vector(strength):
	var x = randf_range(-1*strength,strength)
	var y = randf_range(-1*strength,strength)
	var z = randf_range(-1*strength,strength)
	return Vector3(x,y,z)

func random_up_vector(strength):
	var x = randf_range(-1*strength,strength)
	var y = randf_range(0.3*strength,strength)
	var z = randf_range(-1*strength,strength)
	return Vector3(x,y,z)

func _on_sleeping_state_changed() -> void:
	var result : int = 0;
	if sleeping:
		for ray in raycasts:
			var collides_with_table = ray.is_colliding() and ray.get_collider().is_in_group("Table")
			if collides_with_table:
				if result != 0: # prevent 
					roll()
				result = ray.value
				#roll_finished.emit(ray.value)
		value = result
		freeze = true
		if value == 0:
			roll()
