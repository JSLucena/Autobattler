extends "res://assets/scripts/FSM.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var parent = get_parent()

var target
var next_move
var position
var basic
var atk_timer
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	add_state("idle")
	add_state("acquiring_target")
	add_state("target_acquired") #run and sprint state
	add_state("attack") #basic attack state
	call_deferred("set_state",states.idle)
	
	
	
	 
	
	
	


	
	
func _state_logic(delta): ##in-state logic
	position = parent.get_global_position()
	parent.move_and_collide(parent.velocity * delta)
	
	
	
	match state:
		states.idle:
			parent.velocity = Vector2(20,0)
			pass
		states.acquiring_target:
			
			pass
		states.target_acquired:
			
			next_move = (target.get_global_position() - position).normalized() #pathing calculation
			parent.velocity = next_move * parent.my_stats.speed
			pass
		states.attack:
			if atk_timer.is_stopped():
				atk_timer.start()
				parent.attack(parent.my_skills[0],target)
				
			
				
			pass


func _get_transition(delta): ##between-state transition logic
	
	match state:
		states.idle:
			if parent.in_range == true: ##if something is within reach
				return states.acquiring_target
				
			pass
		states.acquiring_target:
			target = get_next_target()
			return states.target_acquired
			pass
		states.target_acquired:
			if basic.is_colliding():
				print(basic.get_collider().get_name())
				parent.velocity = Vector2(0,0)
				return states.attack
			pass
		states.attack:
			if !basic.is_colliding():
				return states.idle
				
			if target.status == "dead":
				return states.idle
			pass
	return null
func _enter_state(new_state, old_state): ##enter state logic
	
	
	match new_state:
		states.idle:
			parent.get_node("Debug").set_text("idle")
			pass
		states.acquiring_target:
			parent.get_node("Debug").set_text("acquiring target")
			pass
		states.target_acquired:
			parent.get_node("Debug").set_text("target acquired")
			next_move = (target.get_global_position() - position).normalized() 
			parent.velocity = next_move * parent.my_stats.speed
			set_raycast()	
			pass
		states.attack:
			parent.get_node("Debug").set_text("attack")
			set_atkCD()
			parent.attack(parent.my_skills[0],target)
			atk_timer.start()
			parent.get_node("wanderTimer").start()
			pass
func _exit_state(old_state, new_state): ##exit state logic
	match old_state:
		states.idle:
			pass
		states.acquiring_target:
			pass
		states.target_acquired:
			pass
		states.attack:
			basic.set_enabled(false)
			pass
			


func set_raycast():
	basic = parent.get_node("skills").get_node(parent.my_skills[0].skill_name) ##raycast of basic attack
	basic.set_collision_mask_bit(1,false)
	basic.set_collision_mask_bit(5,true)
	basic.set_enabled(true)
	basic.add_exception(parent)
			
	basic.set_cast_to(next_move * (parent.my_skills[0].skill_range - 3))

func set_atkCD():
	atk_timer = Timer.new() #attack cooldown
	atk_timer.set_one_shot(true)
	atk_timer.set_wait_time(parent.my_skills[0].cooldown)
	atk_timer.set_autostart(true)
	atk_timer.set_name(parent.my_skills[0].skill_name + "_timer")
	self.add_child(atk_timer)
	
func get_next_target():
	var inside =  parent.get_node("DetectionRange").get_overlapping_bodies() #gets all bodies within reach
	for i in inside:
		if i.get_name() != parent.get_name():
			if i.status != "dead":
				return i
		


func _on_wanderTimer_timeout():
	var angle = randi() % 360
	parent.velocity = Vector2(cos(angle), sin(angle)) * parent.my_stats.speed/16
	if state == states.attack:
		parent.get_node("wanderTimer").start()
	pass # Replace with function body.
