extends Node

@onready var dice = $"../Dice"
@onready var total_score_label = $"../UI/ScorePanel/VBoxContainer/TotalScore"
@onready var round_score_label = $"../UI/ScorePanel/VBoxContainer/RoundScore"

# var _player : int = 1
var lives = 3
var total_score : int = 0
var round_score : int = 0
var game_round : int = 1
var target_score : int = 4000
var is_game_over : bool = false

var dice_left : int = 6
var round_values : Array = []

func _ready() -> void:
	$"../UI/ScorePanel/VBoxContainer/TargetScore".text = str(target_score)

func evaluate_selected():
	var roll = []
	for die in dice.get_children():
		if not die.is_locked and die.is_selected:
			roll.append(die)
	return evaluate_roll(roll)

func evaluate_roll(roll : Array) -> int:
	var values_to_score = roll.map(func(d): return d.value)
	var score = 0
	var values : Dictionary = {}
	for val : int in values_to_score:
		values[val] = values.get(val, 0) + 1

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

	if total_score >= target_score:
		game_over(true)

	# used all dice without bust
	if dice_left == 0:
		reset_dice()

func reset_dice():
	for die in dice.get_children():
		die.reset()
		dice_left += 1

func finish_round():
	pass

func new_round():
	game_round += 1
	total_score += round_score
	round_score = 0
	dice_left = 6

# func new_game():
# 	total_score = 0
# 	game_round = 0

func bust():
	round_score = 0
	lives -= 1
	var livesText = ""
	for i in lives:
		livesText += "<3 "
	$"../UI/ScorePanel/VBoxContainer/LivesLabel".text = livesText

	if lives == 0:
		game_over(false)
		$"../UI/GameOverPanel".visible = true
		$"../UI/GameOverPanel/FinalScoreLabel".text = str(Global.FINAL_SCORE, total_score)
	else:
		$"../UI/BustPanel".visible = true
		$"../UI/BustPanel/BustTimer".start()
	reset_dice()

func game_over(win: bool):
	if win:
		if not is_game_over:
			$"../UI/WinPanel".visible = true
	else:
		$"../UI/GameOverPanel".visible = true

###### EVENTS ######

func _on_commit_button_pressed() -> void:
	var roll = []
	for die in dice.get_children():
		if not die.is_locked and die.is_selected:
			roll.append(die)
			die.is_locked = true
	commit_roll(roll)

func _on_dice_roll_finished(dice_array: Array) -> void:
	var non_locked_dice = dice_array.filter(func(x): return not x.is_locked)
	var potential_score = evaluate_roll(non_locked_dice)
	print(str("potential_score: ", potential_score, non_locked_dice.map(func(x): return x.value)))
	if potential_score == 0:
		bust()
		

func _on_bust_timer_timeout() -> void:
	$"../UI/BustPanel".visible = false


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_keep_playing_button_pressed() -> void:
	$"../UI/WinPanel".visible = false
