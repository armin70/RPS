extends Node2D
var start_position = Vector2(0,0)
var spacing = 190
var selected_card = null
const card_scene  = preload("uid://fr8hth3x80lv")
const ANNAHITA = preload("uid://7vroo5xw0jr2")
const FIRE_KEEPER = preload("uid://bokl0ibf0nmyt")
const KIMIAGAR = preload("uid://btidd4b2148n8")
const RAKHSH = preload("uid://cwk6sgb5vfb8l")
const ZAHAK = preload("uid://bgjno86u802c2")


func _ready() -> void:
	create_shop_card(0,"Anahita",ANNAHITA,"mult")
	create_shop_card(1,"FireKeeper",FIRE_KEEPER,"point")
	create_shop_card(2,"Kimiagar",KIMIAGAR,"extract")
	create_shop_card(3,"Rakhsh",RAKHSH,"steel")
	create_shop_card(4,"Zahak",ZAHAK,"gold")


func set_selected_card(card,type):
	# قبلی را unselect کن
	if selected_card != null:
		selected_card.unselect()
	selected_card = card

	get_parent().shop_card = type
	selected_card.select()


func create_shop_card(i,card,texture,type):
	var new_card = card_scene.instantiate()
	new_card.setup(card, texture,type)
	if i>2:
		var j = i-3
		new_card.position = start_position + Vector2(j * spacing, 310)
	else:
		new_card.position = start_position + Vector2(i * spacing, 0)
	add_child(new_card)
