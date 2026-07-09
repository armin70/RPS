extends Node2D
var selected_card = null
var start_position = Vector2(0,0)
var spacing = 300

const card_scene  = preload("uid://0ijpvowri8wi")

var hand_center = Vector2(200, 0)

const SCISSORS = preload("uid://c63hfh6k1tb42")
const ROCK = preload("uid://du3im3yd8opkk")
const PAPER = preload("uid://d3wdj12472tyi")

const SPR = preload("uid://vraqgid3bm3e")
const RPS = preload("uid://bbxl4mxpqfex1")
const PRS = preload("uid://srd31jafvknv")



func _ready():
	var i = 0
	for card in GameData.hand_cards:
		i += 1
		var texture
		var type 
		if card == "rock":
			texture = ROCK
			type = "Rock"
		elif card == "paper":
			texture = PAPER
			type = "Paper"
		elif card == "scissors":
			texture = SCISSORS
			type = "Scissors"
		elif card == "RPS":
			texture = RPS
			type = "Random"
		elif card == "SPR":
			texture = SPR
			type = "Random"
		elif card == "PRS":
			texture = PRS
			type = "Random"
			
		create_your_hand(i,card, texture,type)


func create_your_hand(i,card,texture,type):
	var new_card = card_scene.instantiate()
	new_card.setup(name, texture,type)
	new_card.position = start_position + Vector2(i * spacing, 0)
	add_child(new_card)

func get_selected_card(enchant):
	if selected_card:
		selected_card.get_enchant(enchant)


func set_selected_card(card,enchant):
	var type
	# قبلی را unselect کن
	if selected_card != null:
		selected_card.unselect()
	# جدید را انتخاب کن
	selected_card = card
	print("card", card.type)
	#if card.type == 0:
		#type = "Rock"
	#elif card.type == 1:
		#type= "Paper"
	#elif card.type == 2:
		#type = "Scissors"
	if card.type == "Random":
		type = get_random_rps()
	else:
		type = card.type
	get_parent().player_current_enchant = enchant
	get_parent().player_current_card = type
	selected_card.select()

func get_random_rps():
	var RPS = ["Rock","Paper","Scissors"]
	return RPS.pick_random()
