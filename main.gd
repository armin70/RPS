extends Node2D
@onready var player_hp_label : Label = $UI/PlayerHP
@onready var bot_hp_label : Label = $UI/BotHP
@export var max_aspect : float = 1.0

var player_hp := 50
var bot_hp := 50
var max_hp := 50
var is_game_running = true
var bot_current_card = ""
var player_current_card = ""
var multiplier = 0
var debuff = 0
var game_finished := false
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




func submit_card(owner: String):
	var damage = 6
	#$WordDamage.text = str(damage)
	#play_popup_effect($WordDamage)
	#await play_popup_effect($WordDamage)
	#$WordDamage.text = ""
	is_game_running = false
	if owner == "player":
		bot_hp -= damage
		$UI/BotHPDamage.text = "-" + str(damage)
		$UI/BotHPDamage.modulate = Color(1, 0.3, 0.3)
		play_popup_effect($UI/BotHPDamage)
		update_hp_ui()
		await get_tree().create_timer(.4).timeout
		$RPSContainer.remove_type(player_current_card)
		
		for i in range(0,multiplier):
			await get_tree().create_timer(.5).timeout
			$UI/BotHPDamage.text = "-" + str(damage)
			$UI/BotHPDamage.modulate = Color(1, 0.3, 0.3)
			play_popup_effect($UI/BotHPDamage)
			
			bot_hp -= damage
			update_hp_ui()
		await get_tree().create_timer(.5).timeout
		$UI/BotHPDamage.text = "+" + str(debuff)
		$UI/BotHPDamage.modulate = Color(0.0, 0.536, 0.287, 1.0)
		bot_hp += debuff
		play_popup_effect($UI/BotHPDamage)
		
		$RPSContainer.get_debuff(player_current_card)
		update_hp_ui()
		
		var bar = $UI/BotHP
		bar.modulate = Color(1, 0.3, 0.3)
		create_tween().tween_property(bar, "modulate", Color(1,1,1), 0.4)
		print('playeeeeeeeeeer:',(multiplier  * damage) - debuff)
	else:
		player_hp -= damage
		update_hp_ui()
		play_popup_effect($UI/PlayerHPDamage)
		$UI/PlayerHPDamage.text = "-" + str(damage)
		$UI/PlayerHPDamage.modulate = Color(1, 0.3, 0.3)
		await get_tree().create_timer(.4).timeout
		$RPSContainer.remove_type(bot_current_card)
		for i in range(0,multiplier):
			await get_tree().create_timer(.5).timeout
			play_popup_effect($UI/PlayerHPDamage)
			$UI/PlayerHPDamage.text = "-" + str(damage)
			$UI/PlayerHPDamage.modulate = Color(1, 0.3, 0.3)
			player_hp -= damage
			update_hp_ui()
		await get_tree().create_timer(.5).timeout
		player_hp += debuff
		play_popup_effect($UI/PlayerHPDamage)
		$UI/PlayerHPDamage.text = "+" + str(debuff)
		$UI/PlayerHPDamage.modulate = Color(0.0, 0.536, 0.287, 1.0)
		$RPSContainer.get_debuff(bot_current_card)
		update_hp_ui()
		var bar = $"PlayerHPBar"
		bar.modulate = Color(1, 0.3, 0.3)
		create_tween().tween_property(bar, "modulate", Color(1,1,1), 0.4)
		print('boooooooooot:',(multiplier  * damage) - debuff)
	multiplier = 0
	is_game_running = true
	
	update_hp_ui()
	check_game_over()


func check_game_over():

	if player_hp <= 0:
		game_finished = true
		#get_parent().get_parent().game_finished = true
		#get_parent().get_parent().turn_active = false

		#set_buttons_enabled(false)

		#result_label.text = "💀 شما باختید!"
		#end_popup.popup_centered()
		is_game_running = false
		get_tree().paused = true
	elif bot_hp <= 0:
		game_finished = true
		#get_parent().get_parent().game_finished = true
		#get_parent().get_parent().turn_active = false

		#set_buttons_enabled(false)

		#result_label.text = "🏆 شما برنده شدید!"
		#end_popup.popup_centered()
		is_game_running = false
		get_tree().paused = true


func update_hp_ui():
	player_hp_label.text = str(player_hp)
	bot_hp_label.text = str(bot_hp)

	create_tween().tween_property($"PlayerHPBar", "value", player_hp, 0.3)
	create_tween().tween_property($UI/BotHP, "value", bot_hp, 0.3)

func _on_submit_pressed() -> void:
	submit_card("player")
