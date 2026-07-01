extends Node2D
class_name RPSCard

@onready var sprite = $Sprite2D
var is_selected = false

enum CardType {
	ROCK,
	PAPER,
	SCISSORS
}
@export var type: CardType
const ROCK = preload("uid://p3wk5oyhi8jo")

const SCISSOR = preload("uid://cg42218bi1166")

const PAPER = preload("uid://dgxjcxpxmxi4h")

func _ready() -> void:
	if type == 0:
		$Sprite2D.texture = ROCK
	elif type == 1:
		$Sprite2D.texture = PAPER
	elif type == 2:
		$Sprite2D.texture = SCISSOR

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
		print(type)
		get_parent().set_selected_card(self)
