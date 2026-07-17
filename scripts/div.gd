extends Node2D

var is_selected = false
@onready var sprite: Sprite2D = $sprite
var card_name := ""
var card_texture: Texture2D

func select():
	is_selected = true
	sprite.modulate = Color(1, 1, 0.6)
	scale = Vector2(1.1, 1.1)

func unselect():

	is_selected = false
	sprite.modulate = Color(1, 1, 1)
	scale = Vector2(1, 1)

func disable():
	$Area2D.visible = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.pressed:
		if is_selected == true:
			unselect()
			get_parent().remove_div_card(card_name)
		elif is_selected == false :
			if get_parent().div_cards.size() <2:
				select()
				get_parent().set_div_card(card_name)
			

func setup(name: String, texture: Texture2D):
	card_name = name
	card_texture = texture
	$sprite.texture = card_texture
