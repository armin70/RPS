extends Node2D

@export var max_aspect : float = 1.0
@onready var player_point_label: Label = $UI/PlayerPoint
@onready var bot_point_label: Label = $UI/BotPoint
@onready var playermult: Label = $UI/Playermult
@onready var playerscore: Label = $UI/Playerscore
@onready var playergold: Label = $UI/Playergold

var player_score := 0
var player_gold := 0
var player_point := 0
var bot_point := 0
var target_point := 200
var is_game_running = true
var bot_current_card = ""
var player_current_card = ""
var multiplier = 0
var debuff = 0
var game_finished := false
var fire_juice = 0
var water_juice = 0
var thunder_juice = 0
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#set_aspect()

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

	# برگشت به حالت عادی
	tween.tween_property(label, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	# محو شدن
	tween.tween_property(label, "modulate:a", 0.0, 0.6)

	await tween.finished

	label.visible = false

	# برای استفاده بعدی
	label.modulate.a = 1.0
	label.scale = Vector2.ONE

func add_juice(juice,type):
	if type == "fire":
		fire_juice += juice
		$UI/FireLabel.text = "fire: " + str(fire_juice)
	elif type == "water":
		water_juice += juice
		$UI/WaterLabel.text = "water: " + str(water_juice)
	elif type == "thunder":
		thunder_juice += juice
		$UI/ThunderLabel.text = "thunder: " + str(thunder_juice)


func calculate_points(owner: String):
	var point = 10
	var mult = 1
	$RPSContainer.roll_jackpot()
	$RPSContainer.get_debuff(player_current_card)
	await get_tree().create_timer(.4).timeout
	$RPSContainer.remove_type(player_current_card)
	update_hp_ui()
	if debuff:
		for i in debuff:
			point -= i
	player_point_label.text = str(point)
	await get_tree().create_timer(1).timeout
	is_game_running = false
	if owner == "player":
		for i in range(0,multiplier.size()):
			point += point
			player_point_label.text = str(point)
			await get_tree().create_timer(.4).timeout
		player_gold += point
		playergold.text = "gold: " + str(player_gold)
		for i in multiplier:
			mult += i
			playermult.text = str(mult)
			await get_tree().create_timer(.4).timeout
		player_score += point * mult
		playerscore.text = str(player_score)
		await get_tree().create_timer(1.4).timeout

	player_point_label.text = str(0)
	playermult.text = str(0)
	is_game_running = true
	
	update_hp_ui()
	check_game_over()
func submit_card(owner: String):
	var point = 6
	$RPSContainer.roll_jackpot()
	await get_tree().create_timer(1).timeout
	is_game_running = false
	if owner == "player":
		player_point += point
		update_hp_ui()
		await get_tree().create_timer(.4).timeout
		$RPSContainer.remove_type(player_current_card)
		
		for i in multiplier:
			player_point += i * point
			update_hp_ui()
		await get_tree().create_timer(.5).timeout
		if debuff:
			for i in debuff:
				player_point -= i * point
		
		
		$RPSContainer.get_debuff(player_current_card)
		update_hp_ui()
		
	else:
		bot_point += point
		update_hp_ui()
		$RPSContainer.remove_type(bot_current_card)
		for i in multiplier:
			await get_tree().create_timer(.5).timeout
			bot_point += i*point
			update_hp_ui()
		await get_tree().create_timer(.5).timeout
		if debuff:
			for i in debuff:
				bot_point -= i * point
		update_hp_ui()

	multiplier = 0
	is_game_running = true
	
	update_hp_ui()
	check_game_over()


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


func update_hp_ui():
	playerscore.text = str(player_score)
	bot_point_label.text = str(bot_point)


func _on_submit_pressed() -> void:
	calculate_points("player")
