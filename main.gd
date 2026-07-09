extends Node2D

@export var max_aspect : float = 1.0
@onready var player_point_label: Label = $UI/PlayerPoint
@onready var bot_point_label: Label = $UI/BotPoint
@onready var playermult: Label = $UI/Playermult
@onready var playerscore: Label = $UI/Playerscore
@onready var playergold: Label = $UI/Playergold
@onready var botscore: Label = $UI/Botscore
@onready var botmult: Label = $UI/Botmult
@onready var shop_panel: Panel = $UI/ShopPanel

var current_turn 
var player_score := 0
var bot_score := 0
var player_gold := 0
var player_point := 0
var bot_point := 0
var target_point := 200
var is_game_running = true
var bot_current_card = ""
var player_current_card = ""
var player_current_enchant = ""
var multiplier = 0
var debuff = 0
var game_finished := false
var fire_juice = 0
var water_juice = 0
var thunder_juice = 0
var extra_juice = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_panel.visible = false

#func set_aspect():
	#var vp_rect = get_viewport_rect()
	#var aspect = vp_rect.size.x / vp_rect.size.y
	#
	#aspect = min(max_aspect, aspect)
	#
	#$game_container.ratio = aspect
func play_popup_effect(label):
	label.visible = true

	# اگر قبلاً افکتی رویش اجرا شده بود
	label.scale = Vector2.ONE
	label.modulate.a = 1.0

	var tween = create_tween()

	# بزرگ شدن
	tween.tween_property(label, "scale", Vector2(2, 2), 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	# کمی ماندن
	tween.tween_interval(0.5)

	tween.tween_property(label, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(label, "modulate:a", 0.0, 0.6)

	await tween.finished

	label.visible = false

	label.modulate.a = 1.0
	label.scale = Vector2.ONE

func add_juice(juice,type):
	if type == "fire":
		fire_juice += juice + extra_juice
		$UI/FireLabel.text = "fire: " + str(fire_juice)
		if fire_juice >= 15:
			$UI/FirePotion.visible = true
			fire_juice = 15
	elif type == "water":
		water_juice += juice + extra_juice
		$UI/WaterLabel.text = "water: " + str(water_juice)
		if water_juice >= 15:
			$UI/WaterPotion.visible = true
			water_juice = 15
	elif type == "thunder":
		thunder_juice += juice + extra_juice
		$UI/ThunderLabel.text = "thunder: " + str(thunder_juice)
		if thunder_juice >= 15:
			$UI/ThunderPotion.visible = true
			thunder_juice = 15

func calculate_points(owner: String):
	var point = 10
	var mult = 1
	extra_juice = 0
	$RPSContainer.roll_jackpot()

	is_game_running = false
	if owner == "player":
		if player_current_enchant == "mult":
			print("mult added")
			mult += 4
			playermult.text = str(mult)
		elif player_current_enchant == "piont":
			point += 20
			player_point_label.text = str(point)
		elif player_current_enchant == "extract":
			extra_juice = 5
		$RPSContainer.get_debuff(player_current_card)
		await get_tree().create_timer(.4).timeout
		$RPSContainer.remove_type(player_current_card)
		update_hp_ui()
		if debuff:
			for i in debuff:
				point -= i
		player_point_label.text = str(point)
		await get_tree().create_timer(1).timeout
		for i in range(0,multiplier.size()):
			point += point
			player_point_label.text = str(point)
			await get_tree().create_timer(.4).timeout
		player_gold += int(point / 10)
		playergold.text = "gold: " + str(player_gold)
		for i in multiplier:
			mult += i
			playermult.text = str(mult)
			await get_tree().create_timer(.4).timeout
		player_score += point * mult
		playerscore.text = str(player_score)
		await get_tree().create_timer(1.4).timeout
	else:
		$RPSContainer.get_debuff(bot_current_card)
		await get_tree().create_timer(.4).timeout
		$RPSContainer.remove_type(bot_current_card)
		update_hp_ui()
		if debuff:
			for i in debuff:
				point -= i
		bot_point_label.text = str(point)
		await get_tree().create_timer(1).timeout
		for i in range(0,multiplier.size()):
			point += point
			bot_point_label.text = str(point)
			await get_tree().create_timer(.4).timeout
		for i in multiplier:
			mult += i
			botmult.text = str(mult)
			await get_tree().create_timer(.4).timeout
		bot_score += point * mult
		botscore.text = str(bot_score)
		await get_tree().create_timer(1.4).timeout
	player_point_label.text = str(0)
	playermult.text = str(0)
	is_game_running = true
	
	update_hp_ui()
	check_game_over()
	
func get_max_indices(a: int, b: int, c: int) -> Array:
	var max_value = max(a, b, c)
	var result = []

	if a == max_value:
		result.append(0)

	if b == max_value:
		result.append(1)

	if c == max_value:
		result.append(2)

	return result

func perform_bot_move():
	var scissors = 0
	var rocks = 0
	var papers = 0
	print("ربات در حال فکر کردن...")
	await get_tree().create_timer(3.2).timeout
	var locked_items = $RPSContainer.get_locked_items()
	for i in locked_items:
		if i == "Scissors":
			scissors += 1
		elif i == "Rock":
			rocks += 1
		elif i == "Papers":
			papers += 1
	print("rock: ", rocks)
	print("papers: ", papers)
	print("scissors: ", scissors)
	var max_count = max(scissors, rocks, papers)
	var winners = []
	if scissors == max_count:
		winners.append("Rock")

	if rocks == max_count:
		winners.append("Paper")

	if papers == max_count:
		winners.append("Scissors")
	print("winners: ", winners)
	
	bot_current_card = winners.pick_random()
	print("bot_current_card ",bot_current_card)
	calculate_points("bot")


func check_game_over():

	if player_point >= target_point:
		game_finished = true
		#get_parent().get_parent().game_finished = true
		#get_parent().get_parent().turn_active = false

		#set_buttons_enabled(false)

		#result_label.text = "💀 شما باختید!"
		#end_popup.popup_centered()
		is_game_running = false
		get_tree().paused = true
	elif bot_point >= target_point:
		game_finished = true
		#get_parent().get_parent().game_finished = true
		#get_parent().get_parent().turn_active = false

		#set_buttons_enabled(false)

		#result_label.text = "🏆 شما برنده شدید!"
		#end_popup.popup_centered()
		is_game_running = false
		get_tree().paused = true

func _start_bot_turn():
	current_turn = "bot"
	await get_tree().create_timer(3).timeout
	await perform_bot_move()
	if not game_finished:
		_start_player_turn()
	#$RPSContainer.input_enabled = false
	


func _start_player_turn():
	if game_finished: return
	current_turn = "player"
	
	


func update_hp_ui():
	playerscore.text = str(player_score)
	bot_point_label.text = str(bot_point)


func _on_submit_pressed() -> void:
	calculate_points("player")
	_start_bot_turn()


func _on_shop_b_utton_pressed() -> void:
	shop_panel.visible = true

func _on_close_button_pressed() -> void:
	shop_panel.visible = false


func _on_mult_pressed() -> void:
	$hand.get_random_card("mult")


func _on_point_pressed() -> void:
	$hand.get_random_card("point")


func _on_gold_pressed() -> void:
	$hand.get_random_card("gold")


func _on_steel_pressed() -> void:
	$hand.get_random_card("steel")


func _on_extract_pressed() -> void:
	$hand.get_random_card("extract")
