extends RigidBody3D

@onready var raycasts = $Rays.get_children()
var throw_strength = 10
var spin_strength = .5
var rolling = false
var value: int

#signal roll_finished(value)

func roll():
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
	var result : int
	if sleeping:
		for ray in raycasts:
			if ray.is_colliding():
				if result != 0: # prevent 
					roll()
				result = ray.value
				#roll_finished.emit(ray.value)
		value = result
		if value == 0:
			roll()
