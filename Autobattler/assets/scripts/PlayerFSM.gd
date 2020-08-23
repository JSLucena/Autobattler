extends "res://assets/scripts/FSM.gd"

onready var parent = get_parent()

var target #attack target
var next_move #where to go next
var position #self position
var basic #basic attack raycast
var atk_timer #current attack rewind timer
var next_skill #next attack

var seek_force = 200.0

var path = PoolVector2Array()



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	add_state("idle")
	add_state("acquiring_target")
	add_state("target_acquired") #run and sprint state
	add_state("attack") #basic attack state
	add_state("dead")
	call_deferred("set_state",states.idle)
	
	
	
	 
	
	
	


	
	
func _state_logic(delta): ##in-state logic
	position = parent.get_global_position()
	move(delta)
	
	
	
	match state:
		states.idle:
			parent.velocity = Vector2(0,0)
			pass
		states.acquiring_target:
			
			pass
		states.target_acquired:
			get_path()
			next_move = (target.get_global_position() - position).normalized() #pathing calculation
			parent.velocity = next_move * parent.my_stats.speed
			update_target(next_skill) #update target location
			pass
		states.attack:
			next_move = (target.get_global_position() - position).normalized() #pathing calculation
			update_target(next_skill) #update target location
			attack(next_skill,target)
			pass
		states.dead:
			pass

func _get_transition(delta): ##between-state transition logic
	if parent.alive == false:
		return states.dead
	match state:
		states.idle:
			if parent.in_range == true: ##if something is within reach
				return states.acquiring_target
				
			pass
		states.acquiring_target:
			target = get_next_enemy()
			if target == null:
				return states.idle
			return states.target_acquired
			pass
		states.target_acquired:
			if parent.is_in_group("Allies") and target.is_in_group("Allies"):
				return states.idle
			if parent.is_in_group("Enemies") and target.is_in_group("Enemies"):
				return states.idle
			if basic.is_colliding() and basic.get_collider().get_name() == target.get_name():
				#print(basic.get_collider().get_name(), "in range of", parent.get_name())
				parent.velocity = Vector2(0,0)
				return states.attack
			if target.alive == false:
				return states.idle
			pass
		states.attack:
			if !basic.is_colliding():
				return states.idle
				
			if target.alive == false:
				return states.idle
		states.dead:
			if parent.alive == true:
				return states.idle
		
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
			set_raycast()
			next_skill = get_skill()
			pass
		states.attack:
			path = PoolVector2Array() #clean path
			next_skill = get_skill()
			parent.get_node("Debug").set_text("attack")
			set_atkCD(next_skill)
			attack(next_skill,target)
			parent.get_node("wanderTimer").start()
		states.dead:
			parent.get_node("Debug").set_text("dead")
			parent.velocity = Vector2()
			pass
func _exit_state(old_state, new_state): ##exit state logic
	match old_state:
		states.idle:
			pass
		states.acquiring_target:
			get_path()
		states.target_acquired:
			pass
		states.attack:
			basic.set_enabled(false)
			pass
		states.dead:
			pass

func attack(skill,tgt):
	if atk_timer.is_stopped():
		atk_timer.start()
		if skill.skill_range > 3*64:
			parent.shoot(skill,tgt)
		else:
			parent.attack(skill,tgt)
	
func set_raycast():
	basic = parent.get_node("skills").get_node(parent.my_skills[0].skill_name) ##raycast of basic attack
	basic.set_collision_mask_bit(1,false)
	basic.set_collision_mask_bit(5,true)
	basic.set_enabled(true)
	basic.add_exception(parent)
	
	if parent.is_in_group("Allies"):
		for ally in get_tree().get_nodes_in_group("Allies"): #gambiarra pra consertar os arqueiro nao pegando agro se tem aliado na frente
			basic.add_exception(ally)
	if parent.is_in_group("Enemies"):
		for enemy in get_tree().get_nodes_in_group("Enemies"): #gambiarra pra consertar os arqueiro nao pegando agro se tem aliado na frente
			basic.add_exception(enemy)
		
	#print("ray of ", parent.get_name(), " ", basic.is_enabled())
	basic.set_cast_to(next_move * (parent.my_skills[0].skill_range - 3))

func update_target(skill):
	basic.set_cast_to(next_move * (skill.skill_range - 3))

func set_atkCD(skill):
	if not self.get_node(skill.skill_name + "_timer"):
		atk_timer = Timer.new() #attack cooldown
		atk_timer.set_one_shot(true)
		atk_timer.set_wait_time(skill.cooldown)
		atk_timer.set_autostart(true)
		atk_timer.set_name(skill.skill_name + "_timer")
		self.add_child(atk_timer)
	
func get_next_enemy():
	var inside =  parent.get_node("DetectionRange").get_overlapping_bodies() #gets all bodies within reach
	#get closest target
	var closest = inside[1]
	var closest_pos = closest.get_global_position() 
	######
		 ###Gambiarra, ta dando problema quanto tem 2 aliado sozinho longe
	
	
	for i in inside:
		if parent.is_in_group("Allies"): ##Ally AI
			if i.get_name() != parent.get_name() and i.is_in_group("Enemies"):
			
				if i.alive == true:
					###### get closest target
					var i_pos = i.get_global_position()
					if(closest_pos - position) > (i_pos - position):
						closest = i
						closest_pos = i_pos
					elif not closest.is_in_group("Enemies"):
						closest = i
						closest_pos = i_pos
						
		elif parent.is_in_group("Enemies"): ###Enemy AI
			if i.get_name() != parent.get_name() and i.is_in_group("Allies"):
				if i.alive == true:
					###### get closest target
					var i_pos = i.get_global_position()
					if(closest_pos - position) > (i_pos - position):
						closest = i
						closest_pos = i_pos
					elif not closest.is_in_group("Allies"):
						closest = i
						closest_pos = i_pos
	return closest
		
func get_skill():
	
	return parent.my_skills[0]
	pass

func _on_wanderTimer_timeout():
	var angle = randi() % 360
	var vec = Vector2(cos(angle), sin(angle))
	parent.velocity = vec * parent.my_stats.speed/16
	if state == states.attack:
		parent.get_node("wanderTimer").start()
	pass # Replace with function body.
	
func move(delta): 
	if path.size() != 0: #if we are following a path
		var desired = (path[0] - position).normalized() * parent.my_stats.speed
		#parent.velocity += seek() ######## Isso aqui ainda ta meio estranho, olhar novamente outra hora
		parent.velocity = desired
		parent.move_and_slide(parent.velocity)
		if(position.distance_to(path[0]) < 5):
			path.remove(0)
	else:
		parent.move_and_slide(parent.velocity)
	
	
func get_path():
	path = parent.get_parent().get_node("navigationHandler").get_simple_path(position,target.get_global_position(),true) #navigation path
	path.remove(0) #removes first vector, as it is self position
	
func seek(): #por algum motivo fica dando uns stutter de vez em quando
	var steer
	var desired = (path[0] - position).normalized() * parent.my_stats.speed
	steer = (desired - parent.velocity).normalized() * seek_force
	return steer
