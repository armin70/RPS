extends Node2D
var card_name := ""
var card_texture: Texture2D
@onready var sprite = $sprite
var is_selected = false
var type
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
		if is_selected == true:
			unselect()
		elif is_selected == false :
			select()
			get_parent().set_selected_card(self,type)
		
func setup(name: String, texture: Texture2D, card_type: String):
	card_name = name
	card_texture = texture
	type = card_type
	$sprite.texture = card_texture
