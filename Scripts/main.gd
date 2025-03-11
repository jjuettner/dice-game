extends Node3D

@onready var dice = $Dice


func _process(delta: float) -> void:
	#$UI/RollLabel.text = str("Total : ",dice.total_value)
	pass

func _on_roll_button_pressed() -> void:
	dice.roll_all()
