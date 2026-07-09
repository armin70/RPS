extends Node2D
@onready var placeholders =[
	$place1,
	$place2,
	$place3,
	$place4
]
const ROCK = preload("uid://dx1kcjudo0gxe")
const PAPER = preload("uid://cocrlxvcogpqs")
const SCISSORS = preload("uid://c43c7km5wekoc")
var unlocked_items = []
var locked_items = []
var current_item_number =0
var rps = ['Rock','Paper','Scissors']
var variations =  ["fire", "water", "thunder"]
var full_deck = []
func _ready() -> void:
	full_deck_generator()
	generate_RPS()
	

func get_random_unlock():
	unlocked_items = []
	locked_items = []
	var numbers = [0, 1, 2, 3]
	numbers.shuffle()
	for i in range(0,2):
		unlocked_items.append(numbers[i])
	for i in range(2,4):
		locked_items.append(numbers[i])
	print(unlocked_items)
	print("locked_items ",locked_items)
	
	await get_tree().create_timer(1).timeout
	get_locked_items()
	set_locks()

func get_locked_items():
	var locked =[]
	print("locked_items in get lock",locked_items)
	
	for i in locked_items:
		var children = placeholders[i].get_children()
		locked.append(children[0].type)
	return locked

func add_to_placeholder(choices):
	var selected_scene
	var index = -1
	var empty_places = []
	await get_tree().create_timer(1).timeout
	for i in range(0,4):
		print("pre empty",placeholders[i].get_children())
		if placeholders[i].get_children().size() == 0:
			print("empty",i)
			empty_places.append(i)
	print("empty: ", empty_places)
	print("choices:", choices)
	for choice in choices:
		index += 1
		var i = empty_places[index]
		if choice[0] == 'Rock':
			selected_scene =  ROCK.instantiate()
			selected_scene.type = "Rock"
		
		elif choice[0] == 'Paper':
			selected_scene = PAPER.instantiate()
			selected_scene.type = "Paper"
			
		elif choice[0] == 'Scissors':
			selected_scene = SCISSORS.instantiate()
			selected_scene.type = "Scissors"
			
		selected_scene.add_to_group(choice[0])

		placeholders[i].add_child(selected_scene)
		if choice[1] == 'fire':
			print('fire')
			selected_scene.play_fire_animation()
		elif choice[1] == 'water':
			print('water')
			selected_scene.play_water_animation()
		elif choice[1] == 'thunder':
			print('thunder')
			selected_scene.play_thunder_animation()
		current_item_number +=1


func full_deck_generator():
	var card
	var choice
	for i in range(0,30):
		choice = rps.pick_random()
		card = [choice, ""]
		full_deck.append(card)
	for i in range(0,30):
		for variation in variations:
			choice = rps.pick_random()
			card = [choice, variation]
			full_deck.append(card)
	print("full_deck:",full_deck)

func pick_random_card(number):
	var new_deck =[]
	for i in number:
		var index = randi() % full_deck.size()
		var value = full_deck[index]
		var type = value[0]
		var count = 0
		full_deck.remove_at(index)
		new_deck.append(value)
	return new_deck


func roll_jackpot():
	var choice
	var selected_scene
	for item in unlocked_items:
		if placeholders[item].get_children().size()>0 :
			for child in placeholders[item].get_children():
				child.queue_free()
		choice = pick_random_card(1)
		if choice[0][0] == 'Rock':
			selected_scene =  ROCK.instantiate()
			
		elif choice[0][0] == 'Paper':
			selected_scene = PAPER.instantiate()
			
		elif choice[0][0] == 'Scissors':
			selected_scene = SCISSORS.instantiate()
			
		selected_scene.add_to_group(choice[0][0])
		placeholders[item].add_child(selected_scene)

func generate_RPS():
	var choice
	var current_deck = []
	
	for placeholder in placeholders:
		if placeholder.get_children().size()>0 :
			for child in placeholder.get_children():
				child.queue_free()
	#for i in range(0,4):
		#print(i)
		#choice = rps.pick_random()
		#while current_deck.count(choice) > 1 :
			#choice = rps.pick_random()
		#current_deck.append(choice)
	current_deck = pick_random_card(4)
	print("current_deck current_deck",current_deck)
	add_to_placeholder(current_deck)
	get_random_unlock()

func set_locks():
	for i in locked_items:
		var children = placeholders[i].get_children()
		children[0].show_lock()
	for i in unlocked_items:
		var children = placeholders[i].get_children()
		children[0].hide_lock()

	
func remove_type(type_name: String):
	var targets
	var buff = []
	if type_name == "Rock":
		targets = get_tree().get_nodes_in_group("Scissors")
		#current_deck = current_deck.filter(func(item): return item != "Scissors")
		#buff = targets.size()
		#empty_placeholder("Scissors")
	elif type_name == "Paper":
		targets = get_tree().get_nodes_in_group("Rock")
		#current_deck = current_deck.filter(func(item): return item != "Rock")
		#buff = targets.size()
		#empty_placeholder("Rock")
		
	elif type_name == "Scissors":
		targets = get_tree().get_nodes_in_group("Paper")
		#current_deck = current_deck.filter(func(item): return item != "Paper")
		#buff = targets.size()
		#empty_placeholder("Paper")
		
	else:
		print('cant catch')
	if targets:
		for target in targets:
			if target.effected =="fire":
				buff.append(2)
				target.get_buff(2)
				get_parent().add_juice(5,"fire")
			elif target.effected =="water":
				buff.append(2)
				target.get_buff(2)
				get_parent().add_juice(5,"water")
			elif target.effected =="thunder":
				buff.append(2)
				target.get_buff(2)
				get_parent().add_juice(5,"thunder")
				
			else:
				buff.append(1)
				target.get_buff(1)
				
	current_item_number -= targets.size()
	print("current_item_number remove type ",current_item_number)
	get_parent().multiplier = buff
	print("buff: ",buff)
	wait_to_finish_animation(targets)
	await get_tree().create_timer(2).timeout
	fill_free_space()
	await get_tree().create_timer(1).timeout
	
	get_random_unlock()
	
	
	

func wait_to_finish_animation(targets):
	for node in targets:
		node.play_break_animation()

func get_debuff(type_name):
	var targets
	var debuff = []
	if type_name == "Rock":
		targets = get_tree().get_nodes_in_group("Paper")
		#debuff = targets.size()
	elif type_name == "Paper":
		targets = get_tree().get_nodes_in_group("Scissors")
		#debuff = targets.size()
	elif type_name == "Scissors":
		targets = get_tree().get_nodes_in_group("Rock")
		#debuff = targets.size()
	#print("targets:",targets)
	for node in targets:
		node.get_debuff("-1")
	if targets:
		for node in targets:
			if node.effected:
				if node.effected != "":
					debuff.append(3)
					node.get_debuff("-3")
				print("debuffed:",debuff )
			else:
				debuff.append(2)
				node.get_debuff("-2")
				print("debuffed:",debuff )
	#return debuff
	get_parent().debuff = debuff


func fill_free_space():
	print("filled")
	var new_items = []
	print("current_item_number ",current_item_number)
	if current_item_number < 4:
		var free_space = 4 - current_item_number
		print("free_space " ,free_space)
		new_items = pick_random_card(free_space)
			#while current_deck.count(choice) > 1 :
				#choice = rps.pick_random()
			#current_deck.append(choice)
		print("new_items",new_items)
		add_to_placeholder(new_items)

func lock_all():
	locked_items= [0,1,2,3]
	unlocked_items = []
	set_locks()
	get_parent().thunder_juice = 0
	$"../UI/ThunderPotion".visible = false
	$"../UI/ThunderLabel".text = "thunder: " + str(get_parent().thunder_juice)

func reset_board():
	unlocked_items= [0,1,2,3]
	locked_items = []
	roll_jackpot()
	get_random_unlock()
	get_parent().fire_juice = 0
	$"../UI/FirePotion". visible = false
	$"../UI/FireLabel".text = "fire: " + str(get_parent().fire_juice)
	
func swap_locks():
	var temp = locked_items
	locked_items = unlocked_items
	unlocked_items = temp
	set_locks()
	get_parent().water_juice = 0
	$"../UI/WaterPotion".visible = false
	$"../UI/WaterLabel".text = "water: " + str(get_parent().water_juice)


func _on_water_potion_pressed() -> void:
	swap_locks()


func _on_fire_potion_pressed() -> void:
	reset_board()


func _on_thunder_potion_pressed() -> void:
	lock_all()
