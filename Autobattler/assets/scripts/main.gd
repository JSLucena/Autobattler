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

func test_wincondition():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.status != "dead":
			return
	
	get_tree().change_scene("res://scenes/WinScreen.tscn")
