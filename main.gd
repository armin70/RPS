extends Node2D

@export var max_aspect : float = 1.0
@onready var currentPoint: Label = $UI/Point
@onready var currentMult: Label = $UI/mult
@onready var playerscore: Label = $UI/Playerscore
@onready var playergold: Label = $UI/Playergold
@onready var botscore: Label = $UI/Botscore
@onready var shop_panel: Panel = $UI/ShopPanel
@onready var current_score: Label = $UI/current_score

const DIV_CARD = preload("uid://cas8uly5w4yrj")

var current_turn 
var player_score := 0
var bot_score := 0
var player_gold := 16
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
var is_collecting = false
var paper_mult_plus = 0
var rock_mult_plus = 0
var scissors_mult_plus = 0
var more_gold = 0
var shop_card = ""
var player_card_type = ""
var is_pair = false


const D_PAIR = preload("uid://0wjmfs50oxce")
const D_PAPER = preload("uid://578wd0kvqiio")
const D_ROCK = preload("uid://devj4yn7yirfc")
const D_SCISSOR = preload("uid://taqs2xir2owq")
const D_SIBIL = preload("uid://dkcivg0t3ct7a")
const D_WHITE = preload("uid://dsi70kv7g61bl")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("current cards: ", GameData.hand_cards)
	print("current types: ", GameData.type_cards)
	for type in GameData.type_cards:
		var rock_type = GameData.type_cards.count("Rock")
		var paper_type = GameData.type_cards.count("Paper")
		var scissors_type = GameData.type_cards.count("Scissors")

		if [rock_type, paper_type, scissors_type].count(2) == 2:
			is_pair = true
	current_turn = "player"
	var texture
	var i = 0
	for div in GameData.div_cards:
		if div == "white":
			texture = D_WHITE
		elif div == "blue":
			texture = D_ROCK
		elif div == "gold":
			texture = D_PAPER
		elif div == "red":
			texture = D_SCISSOR
		elif div == "purple":
			texture = D_PAIR
		elif div == "blood":
			texture = D_SIBIL
		i += 1
		var div_scene = DIV_CARD.instantiate()
		div_scene.setup(div, texture)
		div_scene.disable()
		
		div_scene.position =  Vector2(i * 280, 0)
		$DivContainer.add_child(div_scene)

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
	print("extra_juice: ", extra_juice)
	if current_turn == "player":
		if type == "fire":
			fire_juice += juice + extra_juice
			$UI/FireLabel.text = str(fire_juice)+ "/15"
			if fire_juice >= 15:
				$UI/FirePotion.visible = true
				fire_juice = 15
				$fire_potion.play("active")
		elif type == "water":
			water_juice += juice + extra_juice
			$UI/WaterLabel.text =  str(water_juice) + "/15"
			if water_juice >= 15:
				$UI/WaterPotion.visible = true
				water_juice = 15
				$water_potion.play("active")
		elif type == "thunder":
			thunder_juice += juice + extra_juice
			$UI/ThunderLabel.text = str(thunder_juice)+ "/15"
			if thunder_juice >= 15:
				$UI/ThunderPotion.visible = true
				thunder_juice = 15
				$thunder_potion.play("active")

func calculate_points(owner: String):
	var point = 10
	var mult = 1
	$RPSContainer.roll_jackpot()
	extra_juice = 0
	
	is_game_running = false
	if owner == "player":
		if is_collecting:
			is_collecting = false
			await get_tree().create_timer(1).timeout
			var plus_mult = await $RPSContainer.collect_similar_type(player_current_card)
			if player_current_card == "Paper":
				paper_mult_plus += plus_mult
			elif player_current_card == "Rock":
				rock_mult_plus += plus_mult
			elif player_current_card == "Scissors":
				scissors_mult_plus += plus_mult
			
		else:
			if GameData.enchanted_cards.size() != 0:
				for enchant in GameData.enchanted_cards:
					var extra_gold = 0
					var extra_mult = 0
					if enchant == "gold":
						extra_gold += 1

					if enchant == "steel":
						extra_mult += 1
					if player_current_enchant == "gold":
						extra_gold -= 1
					if player_current_enchant == "steel":
						extra_mult -= 1
					if extra_gold>0:
						for i in range(0,extra_gold):
							player_gold += 5
							playergold.text = str(player_gold)
					if extra_mult>0:
						for i in range(0,extra_mult):
							mult *= 1.5
							currentMult.text = str(mult)
			if player_current_card == "Paper" and paper_mult_plus != 0 :
				mult += paper_mult_plus
			elif player_current_card == "rock" and rock_mult_plus != 0 :
				mult += rock_mult_plus
			elif player_current_card == "Scissors" and scissors_mult_plus != 0 :
				mult += scissors_mult_plus
			elif player_current_card == "Random":
				var random_type = ["Rock","Paper","Scissors"].pick_random()
				player_current_card = random_type

				if player_card_type == random_type:
					mult += 2
					currentMult.text = str(mult)
			if more_gold != 0:
				player_gold += more_gold
				more_gold = 0
			
			for div in GameData.div_cards:
					if div == "gold":
						if player_current_card == "Paper":
							mult += 4
							currentMult.text = str(mult)
					elif div == "red":
						if player_current_card == "Scissors":
							mult += 4
							currentMult.text = str(mult)
					elif div == "blue":
						if player_current_card == "Rock":
							mult += 4
							currentMult.text = str(mult)
					elif div == "purple":
						if is_pair:
							point += 50
							currentPoint.text = str(point)
			if player_current_enchant == "mult":
				print("mult added")
				mult += 4
				currentMult.text = str(mult)
			elif player_current_enchant == "piont":
				point += 20
				currentPoint.text = str(point)
			elif player_current_enchant == "extract":
				if extra_juice == 0:
					extra_juice = 5
				else:
					extra_juice = 10
					print("extra juice")
			if player_current_card == "needle":
				$RPSContainer.get_debuff("Scissors")
			else:
				print("player_current_card player_current_card ", player_current_card)
				$RPSContainer.get_debuff(player_current_card)
			await get_tree().create_timer(.4).timeout
			if player_current_card == "needle":
				if extra_juice == 0:
					extra_juice = 5
				else:
					extra_juice = 10
				$RPSContainer.remove_type("Scissors")
			else:
				$RPSContainer.remove_type(player_current_card)
			update_hp_ui()
			if debuff:
				for i in debuff:
					point -= i
			currentPoint.text = str(point)
			await get_tree().create_timer(1).timeout
			for i in range(0,multiplier.size()):
				point += point
				currentPoint.text = str(point)
				await get_tree().create_timer(.4).timeout
			player_gold += int(point / 10)
			playergold.text = str(player_gold)
			for i in multiplier:
				mult += i
				currentMult.text = str(mult)
				await get_tree().create_timer(.4).timeout
			for div in GameData.div_cards:
				if div == "white":
					mult += 2
					currentMult.text = str(mult)
					await get_tree().create_timer(.4).timeout
			current_score.text = str(point * mult)
			await get_tree().create_timer(.4).timeout
			player_score += point * mult
			playerscore.text = str(player_score)
			await get_tree().create_timer(1.4).timeout
			current_score.text = str(0)
	else:
		$RPSContainer.get_debuff(bot_current_card)
		await get_tree().create_timer(.4).timeout
		$RPSContainer.remove_type(bot_current_card)
		update_hp_ui()
		if debuff:
			for i in debuff:
				point -= i
		currentPoint.text = str(point)
		await get_tree().create_timer(1).timeout
		for i in range(0,multiplier.size()):
			point += point
			currentPoint.text = str(point)
			await get_tree().create_timer(.4).timeout
		for i in multiplier:
			mult += i
			currentMult.text = str(mult)
			await get_tree().create_timer(.4).timeout
		current_score.text = str(point * mult)
		await get_tree().create_timer(.4).timeout
		bot_score += point * mult
		
		botscore.text = str(bot_score)
		await get_tree().create_timer(1.4).timeout
		current_score.text = str(0)
	currentPoint.text = str(0)
	currentMult.text = str(0)
	is_game_running = true
	extra_juice = 0
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

func switch_input(is_enabled):
	if is_enabled:
		$UI/submit.disabled = false
		$UI/WaterPotion.disabled = false
		$UI/FirePotion.disabled = false
		$UI/ThunderPotion.disabled = false
	else:
		$UI/submit.disabled = true
		$UI/WaterPotion.disabled = true
		$UI/FirePotion.disabled = true
		$UI/ThunderPotion.disabled = true
		
func _start_bot_turn():
	switch_input(false)
	await get_tree().create_timer(3).timeout
	current_turn = "bot"
	print("current_turn ",current_turn)
	await perform_bot_move()
	if not game_finished:
		_start_player_turn()
	#$RPSContainer.input_enabled = false


func _start_player_turn():
	if game_finished: return
	switch_input(true)
	
	await get_tree().create_timer(3).timeout
	current_turn = "player"
	print("current_turn ",current_turn)
	

func update_hp_ui():
	playerscore.text = str(player_score)
	currentPoint.text = str(bot_point)


func _on_submit_pressed() -> void:
	$jackpot.play("start")
	calculate_points("player")
	_start_bot_turn()


func _on_shop_b_utton_pressed() -> void:
	shop_panel.visible = true

func _on_close_button_pressed() -> void:
	shop_panel.visible = false


func _on_pay_pressed() -> void:
	if shop_card !="":
		if player_gold >= 8:
			player_gold -= 8
			playergold.text = str(player_gold)
			print("shop_card ", shop_card)
			$hand.get_selected_card(shop_card)


func _on_guide_pressed() -> void:
	$UI/guide_panel.visible = true


func _on_return_pressed() -> void:
	$UI/guide_panel.visible = false
