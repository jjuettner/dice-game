extends Node

const LABEL_ROLL_TOTAL = "Total: "
const LABEL_ROLL_Values = "Values: "

func random_vector(strength):
	var x = randf_range(-1*strength,strength)
	var y = randf_range(-1*strength,strength)
	var z = randf_range(-1*strength,strength)
	return Vector3(x,y,z)

func random_up_vector(strength):
	var x = randf_range(-1*strength,strength)
	var y = randf_range(0.3*strength,strength) + 1
	var z = randf_range(-1*strength,strength)
	return Vector3(x,y,z)

func get_object_at_cursor(world: World3D, camera: Camera3D):
	var space_state = world.direct_space_state  # Get the physics space
	var mouse_pos = get_viewport().get_mouse_position()  # Get mouse position
	var ray_origin = camera.project_ray_origin(mouse_pos)  # Convert to 3D position
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000  # Cast the ray far

	# Define raycast query
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true  # Enable area collision if needed

	var result = space_state.intersect_ray(query).collider  # Perform the raycast

	return result
