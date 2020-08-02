extends Node2D

class_name fighter

signal damage(value, target)

onready var FOV = $DetectionRange/shape
onready var my_stats = $stats.stats
onready var current_health = my_stats.max_health
onready var current_mana = my_stats.max_mana
onready var my_skills = $skills.skills

var velocity = Vector2()

var status = "alive"




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
	detection.set_radius(my_stats.view_distance) #64 pixels = 1 meter
	var shape = CollisionShape2D.new()
	FOV.set_shape(detection)
	
	#set WanderTimer
	$wanderTimer.set_wait_time(0.3)
	$wanderTimer.set_one_shot(true)
	
	
	

func _process(delta):
	update()
	pass
	
func _draw():
	if in_range == true:
		draw_circle($Sprite.get_position(), my_stats.view_distance, Color( 1, 0, 0, 0.2 )) #FOV drawing
	else:
		draw_circle($Sprite.get_position(), my_stats.view_distance, Color( 0.37, 0.62, 0.63, 0.2 )) #FOV drawing
		
	if $charFSM.state == $charFSM.states.attack && $charFSM.atk_timer.is_stopped():
		$Sprite.set_modulate(Color(1,0,1,1))
	else:
		$Sprite.set_modulate(Color(0,0,1,0.5))
		




	


func _on_DetectionRange_body_entered(body):
	if body != self: #exclude self
		in_range = true
		print(body.get_name(), " entered")


func _on_DetectionRange_body_exited(body):
	if body != self: #exclude self
		print(body.get_name(), " left")
		if $DetectionRange.get_overlapping_bodies().size() <= 1: #if there are more than one enemy around
			in_range = false
	
func attack(skill, target):
	
	target.take_damage(skill.base_damage)
	
func take_damage(damage):
	var old_health = current_health
	if(current_health > 0):
		current_health -= damage
		blink_when_damage()
		$HPBar.update_health(current_health,old_health)
	elif (current_health - damage > 0):
		current_health -= damage
		$HPBar.update_health(current_health,old_health)
		blink_when_damage()
		die()
	else:
		die()

func die():
	status = "dead"
	$hitbox.disabled(true)

func blink_when_damage():
	$spriteBlinkTimer.set_wait_time(0.5)
	$spriteBlinkTimer.set_one_shot(true)
	$spriteBlinkTimer.start()
	
	$Sprite.set_modulate(Color(1,0,0,1))






func _on_spriteBlinkTimer_timeout():
	$Sprite.set_modulate(Color(1,0,0,0.5))
	pass # Replace with function body.
