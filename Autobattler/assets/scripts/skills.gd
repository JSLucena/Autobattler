extends Node2D


class_name char_skills


export var skills = []
func _ready():
	
	for i in skills:
	#	var skill_range = CircleShape2D.new()
	#	skill_range.set_radius(i.skill_range) #64 pixels = 1 meter
		#var area2D = Area2D.new()
		#area2D.set_shape(skill_range)
		#area2D.set_name(i.skill_name)
		var skill_range = RayCast2D.new()
		skill_range.set_name(i.skill_name)
		add_child(skill_range)
		
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
