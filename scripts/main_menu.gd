extends Node2D
var div_cards = []
var hand_cards = []
const DivCardScene = preload("uid://cas8uly5w4yrj")
const HAND_CARD_MENU = preload("uid://b1irbc2wn0827")

var div_spacing = 270
var start_div_position = Vector2(300, 30)

var hand_spacing = 230
var start_hand_position = Vector2(300, 600)
const D_PAIR = preload("uid://0wjmfs50oxce")
const D_PAPER = preload("uid://578wd0kvqiio")
const D_ROCK = preload("uid://devj4yn7yirfc")
const D_SCISSOR = preload("uid://taqs2xir2owq")
const D_SIBIL = preload("uid://dkcivg0t3ct7a")
const D_WHITE = preload("uid://dsi70kv7g61bl")

const SCISSORS = preload("uid://c63hfh6k1tb42")
const ROCK = preload("uid://du3im3yd8opkk")
const PAPER = preload("uid://d3wdj12472tyi")
const PRS = preload("uid://srd31jafvknv")
const RPS = preload("uid://bbxl4mxpqfex1")
const SPR = preload("uid://vraqgid3bm3e")
const BOOK = preload("uid://ohxowre6p0b5")
const WHEELBARROW = preload("uid://8kelx71ch6lc")
const TAILOR_BOX = preload("uid://vi8kq3bemh41")
const CREDIT_CARD = preload("uid://cliks50adfomc")
const STATUE = preload("uid://63bpqm6ogal8")
const NEEDLE = preload("uid://b8aqd8euy4e2p")


func _ready() -> void:
	create_div_card(0,"white",D_WHITE)
	create_div_card(1,"blue",D_ROCK)
	create_div_card(2,"gold",D_PAPER)
	create_div_card(3,"red",D_SCISSOR)
	create_div_card(4,"purple",D_PAIR)
	create_div_card(5,"blood",D_SIBIL)
	create_hand_card(1,"rock",ROCK )
	create_hand_card(2,"paper",PAPER )
	create_hand_card(3,"scissors",SCISSORS )
	create_hand_card(4,"PRS",PRS )
	create_hand_card(5,"RPS",RPS )
	create_hand_card(6,"SPR",SPR )
	create_hand_card(7,"Book",BOOK )
	create_hand_card(8,"WheelBarrow",WHEELBARROW )
	create_hand_card(9,"TailorBox",TAILOR_BOX )
	create_hand_card(10,"CreditCard",CREDIT_CARD )
	create_hand_card(11,"Statue",STATUE )
	create_hand_card(12,"Needle",NEEDLE )



func create_hand_card(i,name,texture):
	var card = HAND_CARD_MENU.instantiate()

	card.setup(name, texture)
	if i <= 6:
		card.position = start_hand_position + Vector2(i * hand_spacing, 0)
	else:
		var j = i - 6
		card.position = start_hand_position + Vector2(j * hand_spacing, 320)
		

	add_child(card)



func create_div_card(i,name,texture):

	var card = DivCardScene.instantiate()

	card.setup(name, texture)

	card.position = start_div_position + Vector2(i * div_spacing, 0)

	add_child(card)

func set_div_card(card):
	if div_cards.size() < 2:
		div_cards.append(card)
		print(div_cards)

func remove_div_card(card):
	div_cards.erase(card)
	print(div_cards)

func set_hand_card(card):
	if hand_cards.size() < 4 :
		hand_cards.append(card)
		print(hand_cards)

func remove_hand_card(card):
	hand_cards.erase(card)
	print(hand_cards)
	

func _on_button_pressed() -> void:
	if hand_cards.size() ==  4 and div_cards.size() == 2:
		$start.play("start")
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		GameData.div_cards = div_cards
		GameData.hand_cards = hand_cards
