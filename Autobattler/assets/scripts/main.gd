extends Node2D




var  movement = Vector2()


func _ready():
	$Fighter.connect("damage",self,"handle_damage")
	pass 


func _process(delta):
	#movement = Vector2(100,0)
	#$Fighter.move_and_collide(movement*delta)
	pass
	
	
func handle_damage(value,target):
	target.take_damage(value) 
	pass


