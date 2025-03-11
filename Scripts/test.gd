extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ray = $RayCast3D
	print(ray.is_colliding())
	print(ray.get_collider())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
