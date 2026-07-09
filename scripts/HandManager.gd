extends Node2D
var selected_card = null
var start_position = Vector2(0,0)
var spacing = 200

const card_scene  = preload("uid://0ijpvowri8wi")

var hand_center = Vector2(200, 0)

const SCISSORS = preload("uid://c63hfh6k1tb42")
const ROCK = preload("uid://du3im3yd8opkk")
const PAPER = preload("uid://d3wdj12472tyi")
const WHEELBARROW = preload("uid://8kelx71ch6lc")
const TAILOR_BOX = preload("uid://vi8kq3bemh41")
const BOOK = preload("uid://ohxowre6p0b5")

const CREDIT_CARD = preload("uid://cliks50adfomc")
const NEEDLE = preload("uid://b8aqd8euy4e2p")
const STATUE = preload("uid://63bpqm6ogal8")


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
		elif card == "Book":
			texture = BOOK
			type = "Collector"
		elif card == "WheelBarrow":
			texture = WHEELBARROW
			type = "Collector"
		elif card == "TailorBox":
			texture = TAILOR_BOX
			type = "Collector"
		elif card == "CreditCard":
			texture = CREDIT_CARD
			type = "Credit"
		elif card == "Statue":
			texture = STATUE
			type = "Statue"
		elif card == "Needle":
			texture = NEEDLE
			type = "Needle"
			
		create_your_hand(i,card, texture,type)


func create_your_hand(i,card,texture,type):
	var new_card = card_scene.instantiate()
	new_card.setup(card, texture,type)
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
	if card.type == "Credit":
		print("Credit")
		get_parent().more_gold = 3
		type = "Paper"
	elif card.type == "Statue":
		print("Statue")
		type = "Rock"
		if card.enchant == "gold":
			get_parent().more_gold = 5
	elif card.type == "Needle":
		
		type = "Scissors"
		get_parent().extra_juice = 5
	elif card.type == "Collector":
		get_parent().is_collecting = true
		if card.card_name == "Book":
			type = "Paper"
		elif card.card_name == "WheelBarrow":
			type = "Rock"
		elif card.card_name == "TailorBox":
			type = "Scissors"
	elif card.type == "Random":
		type = get_random_rps()
	else:
		type = card.type
	get_parent().player_current_enchant = enchant
	get_parent().player_current_card = type
	selected_card.select()

func get_random_rps():
	var RPS = ["Rock","Paper","Scissors"]
	return RPS.pick_random()
