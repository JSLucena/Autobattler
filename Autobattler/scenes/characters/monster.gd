extends KinematicBody2D

class_name monster1

onready var FOV = $DetectionRange/shape
onready var my_stats = $stats.stats
onready var current_health = my_stats.max_health
onready var current_mana = my_stats.max_mana






##debug
var in_range
###

func _ready():
	
	#Stat bars initialization
	$HPBar.update_max_health(my_stats.max_health)
	$HPBar.update_health(current_health, current_health)
	$HPBar.set_min_health()
	$MPBar.update_max_health(my_stats.max_mana)
	$MPBar.update_health(current_mana, current_mana)
	$MPBar.set_min_health()
	
	
	
	#Field of View initialization
	var detection = CircleShape2D.new()
	detection.set_radius(my_stats.view_distance) 
	var shape = CollisionShape2D.new()
	FOV.set_shape(detection)
	
	
	

func _process(delta):
	_draw()
	pass
	
func _draw():
	if in_range == true:
		draw_circle($Sprite.get_position(), my_stats.view_distance, Color( 1, 0, 0, 0.2 )) #FOV drawing
	else:
		draw_circle($Sprite.get_position(), my_stats.view_distance, Color( 0.37, 0.62, 0.63, 0.2 )) #FOV drawing




	


func _on_DetectionRange_body_entered(body):
	in_range = true
	print(body, "entered")
	pass # Replace with function body.


func _on_DetectionRange_body_exited(body):
	print(body, "left")
	in_range = false
	pass # Replace with function body.

