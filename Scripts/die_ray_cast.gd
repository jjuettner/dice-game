extends RayCast3D

@export var value: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_exception(owner)
	pass # Replace with function body.
