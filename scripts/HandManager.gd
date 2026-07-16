extends Node2D
var selected_card = null
var start_position = Vector2(0,0)
var spacing = 300

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
			GameData.type_cards.append("Rock")
		elif card == "paper":
			texture = PAPER
			type = "Paper"
			GameData.type_cards.append("Paper")
		elif card == "scissors":
			texture = SCISSORS
			type = "Scissors"
			GameData.type_cards.append("Scissors")
		elif card == "RPS":
			texture = RPS
			type = "RPS"
			GameData.type_cards.append("Rock")
			
		elif card == "SPR":
			texture = SPR
			type = "SPR"
			GameData.type_cards.append("Scissors")
			
		elif card == "PRS":
			texture = PRS
			type = "PRS"
			GameData.type_cards.append("Paper")
			
		elif card == "Book":
			texture = BOOK
			type = "Collector"
			GameData.type_cards.append("Paper")
			
		elif card == "WheelBarrow":
			texture = WHEELBARROW
			type = "Collector"
			GameData.type_cards.append("Rock")
			
		elif card == "TailorBox":
			texture = TAILOR_BOX
			type = "Collector"
			GameData.type_cards.append("Scissors")
			
		elif card == "CreditCard":
			texture = CREDIT_CARD
			type = "Credit"
			GameData.type_cards.append("Paper")
			
		elif card == "Statue":
			texture = STATUE
			type = "Statue"
			GameData.type_cards.append("Rock")
			
		elif card == "Needle":
			texture = NEEDLE
			type = "Needle"
			GameData.type_cards.append("Scissors")
			
		create_your_hand(i,card, texture,type)


func create_your_hand(i,card,texture,type):
	var new_card = card_scene.instantiate()
	new_card.setup(card, texture,type)
	new_card.position = start_position + Vector2(i * spacing, 0)
	add_child(new_card)

func get_selected_card(enchant):
	if selected_card:
		selected_card.get_enchant(enchant)
		if selected_card.check_enchant() == "":
			GameData.enchanted_cards.append(enchant)
		else:
			GameData.enchanted_cards.erase(selected_card.check_enchant())
			GameData.enchanted_cards.append(enchant)


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
		get_parent().player_card_type = ""
		
	elif card.type == "Statue":
		print("Statue")
		type = "Rock"
		get_parent().player_card_type = ""
		
		if card.enchant == "gold":
			get_parent().more_gold = 5
	elif card.type == "Needle":
		print("Needle")
		type = "needle"
		get_parent().player_card_type = ""
		
	elif card.type == "Collector":
		get_parent().is_collecting = true
		if card.card_name == "Book":
			type = "Paper"
			get_parent().player_card_type = ""
			
		elif card.card_name == "WheelBarrow":
			type = "Rock"
			get_parent().player_card_type = ""
			
		elif card.card_name == "TailorBox":
			type = "Scissors"
			get_parent().player_card_type = ""
	elif card.type == "PRS":
		get_parent().player_card_type = "Paper"
		type = "Random"
	elif card.type == "RPS":
		get_parent().player_card_type = "Rock"
		type = "Random"
	elif card.type == "SPR":
		get_parent().player_card_type = "Scissors"
		type = "Random"
	else:
		type = card.type
	get_parent().player_current_enchant = card.enchant
	get_parent().player_current_card = type
	selected_card.select()

func get_random_rps():
	var RPS = ["Rock","Paper","Scissors"]
	return RPS.pick_random()
