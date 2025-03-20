extends Node

@onready var dice = $"../Dice"
@export var total_score_label: Label
@export var round_score_label: Label
@export var throw_score_label: Label
@export var target_score_label: Label
@export var lives_label: Label
@export var roll_button: Button
@export var commit_button: Button

signal is_bust()

# var _player : int = 1
var lives = 3
var total_score : int = 0
var round_score : int = 0
var throw_score : int = 0
var game_round : int = 1
var target_score : int = 4000
var is_game_over : bool = false

var dice_left : int = 6
var round_values : Array = []

func _ready() -> void:
	target_score_label.text = str(target_score)
	roll_button.visible = true
	commit_button.visible = false

func evaluate_selected():
	var roll = []
	for die in dice.get_children():
		if not die.is_locked and die.is_selected:
			roll.append(die)
	return evaluate_roll(roll)

func evaluate_roll(roll : Array) -> Array:
	var values_to_score = roll.map(func(d): return d.value)
	var score = 0
	var counted_dice = 0
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
				base_score = 1000
			else:
				base_score += val * 100
			score += base_score * (values[val] - 2)
			for i in range(values[val]):
				values_to_score.remove_at(values_to_score.find(val))
				counted_dice += 1
			
	# single dice
	for val in values_to_score:
		if val == 1:
			score += 100
			counted_dice += 1
		if val == 5:
			score += 50
			counted_dice += 1

	# set_throw_score(score)
	var is_held_dice_valid = roll.size() > 0 and roll.size() - counted_dice == 0 and score > 0  
	return [score, is_held_dice_valid]

func set_total_score(score : int):
	total_score = score
	total_score_label.text = str(total_score)

func set_round_score(score : int):
	round_score = score
	round_score_label.text = str(round_score)

func set_throw_score(score : int):
	throw_score = score
	throw_score_label.text = str(throw_score)


func lose_life():
	lives -= 1
	var livesText = ""
	for i in range(lives):
		livesText += "<3 "
	lives_label.text = livesText

	if lives == 0:
		game_over(false)
		$"../UI/GameOverPanel".visible = true
		$"../UI/GameOverPanel/FinalScoreLabel".text = str(Global.FINAL_SCORE, round_score)
	else:
		$"../UI/BustPanel".visible = true
		$"../UI/BustPanel/BustTimer".start()


func commit_roll():
	set_round_score(round_score + throw_score)
	set_throw_score(0)

	var roll = []
	for die in dice.get_children():
		if not die.is_locked and die.is_selected:
			roll.append(die)
			die.is_locked = true

	# append values
	round_values = round_values + roll
	dice_left -= roll.size()

	if total_score >= target_score:
		game_over(true)

	# used all dice without bust
	if dice_left == 0:
		dice.reset()
		dice_left = dice.get_children().size()

	commit_button.visible = false


func new_round():
	set_total_score(total_score + round_score)
	set_round_score(0)
	lose_life()
	dice.reset()
	game_round += 1
	dice_left = 6


func bust():
	set_throw_score(0)
	set_round_score(0)
	lose_life()
	dice.reset()
	commit_button.visible = false
	is_bust.emit()


func game_over(win: bool):
	if win:
		if not is_game_over:
			$"../UI/WinPanel".visible = true
	else:
		$"../UI/GameOverPanel".visible = true

###### EVENTS ######

func _on_commit_button_pressed() -> void:
	commit_roll()
	dice.roll_all()

func _on_end_turn_button_pressed() -> void:
	commit_roll()
	new_round()

func _on_dice_roll_finished(dice_array: Array) -> void:
	var non_locked_dice = dice_array.filter(func(x): return not x.is_locked)
	var potential_score = evaluate_roll(non_locked_dice)[0]
	print(str("potential_score: ", potential_score, non_locked_dice.map(func(x): return x.value)))
	if potential_score == 0:
		bust()
		

func _on_bust_timer_timeout() -> void:
	$"../UI/BustPanel".visible = false


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_keep_playing_button_pressed() -> void:
	$"../UI/WinPanel".visible = false


func _on_dice_selected() -> void:
	print("die selected, evaluate...")
	var evalResult = evaluate_selected()
	print(evalResult)
	var tmp_score = evalResult[0]
	if evalResult[1]:
		commit_button.visible = true
	else:
		commit_button.visible = false
	print(str("die selected, evaluate... ",tmp_score))
	set_throw_score(tmp_score)
