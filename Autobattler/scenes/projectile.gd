extends KinematicBody2D

onready var parent = get_parent()
var target_pos
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	target_pos = parent.get_node("charFSM").target.get_global_position()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = (target_pos - self.get_global_position()).normalized() * 16*64
	move_and_collide(velocity * delta)
	pass


func _on_hitbox_body_entered(body):
	parent.attack(parent.this_shot_is,body)
	self.queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	self.queue_free()
	pass # Replace with function body.
