extends Node2D
var potion_effect
var effected
var type



func play_break_animation(is_potion_break):

	if is_potion_break:
		var neighbors =  get_parent().get_neighbors(self)
		print("neighbors: ",neighbors )
		for neighbor in neighbors:
			if neighbor:
				neighbor.get_effect(potion_effect,false)
	$animation.play("break")
	await get_tree().create_timer(2).timeout
	get_parent().items.erase(self)
	queue_free()


func get_debuff(debuff):
	print("debuff value: ", debuff)
	$debuff.text = debuff
	await get_tree().create_timer(2).timeout
	$debuff.text = ""
func get_buff(buff):
	$Multiplier.text = "x"+ str(buff)
	await get_tree().create_timer(2).timeout
	$Multiplier.text = ""


func play_fire_animation():
	$animation.play("fire")
	effected="fire"
	
	await $animation.animation_finished
	if type == 'Paper':
		queue_free()
 
func play_water_animation():
	$animation.play("water")
	effected="water"
	
	await $animation.animation_finished
	if type == 'Scissors':
		queue_free()
 
func play_thunder_animation():
	$animation.play("thunder")
	effected="thunder"
	
	await $animation.animation_finished
	if type == 'Rock':
		queue_free()
