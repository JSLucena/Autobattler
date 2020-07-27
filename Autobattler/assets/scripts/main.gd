extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var  movement = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	movement = Vector2(100,0)
	$Fighter.move_and_collide(movement*delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
