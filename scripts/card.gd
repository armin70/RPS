extends Node2D
class_name RPSCard
var card_name := ""
var card_texture: Texture2D
@onready var sprite = $sprite
var is_selected = false
var enchant = ''
enum CardType {
	ROCK,
	PAPER,
	SCISSORS
}
var type =""
const ROCK = preload("uid://du3im3yd8opkk")

const SCISSOR = preload("uid://c63hfh6k1tb42")

const PAPER = preload("uid://d3wdj12472tyi")

@onready var enchant_effect: Sprite2D = $EnchantEffect


const MULT = preload("uid://blgn0fbvf6dlh")
const STEEL = preload("uid://bui3cdf5nyabh")
const BONUS = preload("uid://dtrqbc7krbwrl")
const GOLD = preload("uid://baorueqgaf5x4")
const LUCKY = preload("uid://gr3tq3ndtqu6")

#func _ready() -> void:
	#if type == 0:
		#$Sprite2D.texture = ROCK
	#elif type == 1:
		#$Sprite2D.texture = PAPER
	#elif type == 2:
		#$Sprite2D.texture = SCISSOR

func select():

	is_selected = true
	sprite.modulate = Color(1, 1, 0.6)
	scale = Vector2(1.1, 1.1)

func unselect():

	is_selected = false
	sprite.modulate = Color(1, 1, 1)
	scale = Vector2(1, 1)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		perform_card()

func perform_card():
	get_parent().set_selected_card(self,enchant)

func get_enchant(e):
	enchant = e
	var selected_enchant
	if e == "mult":
		selected_enchant =  MULT
	elif e == "point":
		selected_enchant = BONUS
	elif e == "steel":
		selected_enchant = STEEL
	elif e == "gold":
		selected_enchant = GOLD
	elif e == "extract":
		selected_enchant = LUCKY
	enchant_effect.texture = selected_enchant

func setup(name: String, texture: Texture2D, card_type: String):
	card_name = name
	card_texture = texture
	type = card_type
	$sprite.texture = card_texture
