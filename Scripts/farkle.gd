extends Node

@onready var dice = $"../Dice"
@onready var total_score_label = $"../UI/ScorePanel/VBoxContainer/TotalScore"
@onready var round_score_label = $"../UI/ScorePanel/VBoxContainer/RoundScore"

var _player : int = 1
var total_score : int = 0
var round_score : int = 0
var game_round : int = 1

var dice_left : int = 6
var dice_selected : int = 0
var game_over : bool= false
var round_values : Array = []

func evaluate_selected():
	var roll = []
	for die in dice.get_children():
		if not die.is_locked and die.is_selected:
			roll.append(die)
	return evaluate_roll(roll)

func evaluate_roll(dice : Array) -> int:
	var values_to_score = dice.map(func(d): return d.value)
	var score = 0
	var values : Dictionary = {}
	for val : int in values_to_score:
		values[val] = values.get(val, 0) + 1

	print("values")
	print(values)
	# straights
	if values.has(1) and values.has(2) and values.has(3) and values.has(4) and values.has(5):
		score += 500
	if values.has(2) and values.has(3) and values.has(4) and values.has(5) and values.has(6):
		score += 750
	if values.has(1) and values.has(2) and values.has(3) and values.has(4) and values.has(5) and values.has(6):
		score += 1500

	# x of a kind
	for val in values:
		var base_score = 0
		if values[val] >= 3:
			if(val == 1):
				base_score = 100
			else:
				base_score += val * 100
			score += base_score * (values[val] - 2)
			for i in range(values[val]):
				values_to_score.remove_at(values_to_score.find(val))
			
	
	# single dice
	for val in values_to_score:
		if val == 1:
			score += 100
		if val == 5:
			score += 50
		# values_to_score.remove_at(values_to_score.find(val))

	round_score = score
	return score

func commit_roll(roll : Array):
	round_score = evaluate_roll(roll)
	total_score += round_score
	total_score_label.text = str(total_score)
	round_score = 0
	round_score_label.text = str(round_score)
	# append values
	round_values = round_values + roll
	dice_left -= roll.size()
	dice_selected += roll.size()

	if dice_left == 0:
		$"../Dice".reset()
		# TODO: second reset doesn't work



func bust():
	print("bust")
	# game_over = true
	pass

func finish_round():
	pass

func new_round():
	game_round += 1
	total_score += round_score
	round_score = 0
	dice_left = 6
	dice_selected = 0

func new_game():
	total_score = 0
	game_round = 0


func _on_commit_button_pressed() -> void:
	var roll = []
	for die in dice.get_children():
		if not die.is_locked and die.is_selected:
			roll.append(die)
			die.is_locked = true
	commit_roll(roll)
	pass # Replace with function body.
