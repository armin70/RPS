extends Node2D
var selected_card = null
const card_scene  = preload("uid://0ijpvowri8wi")
var rock_card
var paper_card
var scissors_card
var hand_center = Vector2(200, 0)
var spacing = 300
var availabvle_cards =["Rock","Paper","Scissors"]

func layout_hand():

	rock_card.position = hand_center + Vector2(-spacing, 0)
	paper_card.position = hand_center + Vector2(0, 0)
	scissors_card.position = hand_center + Vector2(spacing, 0)

func _ready():

	rock_card = card_scene.instantiate()
	rock_card.type = RPSCard.CardType.ROCK
	add_child(rock_card)

	paper_card = card_scene.instantiate()
	paper_card.type = RPSCard.CardType.PAPER
	add_child(paper_card)

	scissors_card = card_scene.instantiate()
	scissors_card.type = RPSCard.CardType.SCISSORS
	add_child(scissors_card)
	layout_hand()

func get_random_card(enchant):
	if availabvle_cards.size() == 0:
		availabvle_cards =["Rock","Paper","Scissors"]
	var choice = availabvle_cards.pick_random()
	availabvle_cards.erase(choice)
	if choice == "Rock":
		rock_card.get_enchant(enchant)
	elif choice == "Paper":
		paper_card.get_enchant(enchant)
	elif choice == "Scissors":
		scissors_card.get_enchant(enchant)

func set_selected_card(card,enchant):
	var type
	# قبلی را unselect کن
	if selected_card != null:
		selected_card.unselect()
	# جدید را انتخاب کن
	selected_card = card
	print("card", card.type)
	if card.type == 0:
		type = "Rock"
	elif card.type == 1:
		type= "Paper"
	elif card.type == 2:
		type = "Scissors"
	get_parent().player_current_enchant = enchant
	
		
	get_parent().player_current_card = type
	selected_card.select()
