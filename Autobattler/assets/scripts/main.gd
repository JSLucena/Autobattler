extends Node2D




var  movement = Vector2()


func _ready():
	#$Fighter.connect("damage",self,"handle_damage")
	
	pass 


func _process(delta):
	#movement = Vector2(100,0)
	#$Fighter.move_and_collide(movement*delta)
	
	pass
	
	
#func handle_damage(value,target):
#	target.take_damage(value) 
#	pass

func test_winCondition(body):
	print(body.get_name(), " died " , body.is_in_group("Allies"))
	if body.is_in_group("Allies"):
		for ally in get_tree().get_nodes_in_group("Allies"):
			if ally.alive == true:
				return
		get_tree().change_scene("res://scenes/WinScreen.tscn")
	elif body.is_in_group("Enemies"):
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if enemy.alive == true:
				return
		get_tree().change_scene("res://scenes/WinScreen.tscn")
	return
