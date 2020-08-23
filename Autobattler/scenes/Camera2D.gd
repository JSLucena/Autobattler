extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		self.position = self.position + Vector2(0,-3)
	if Input.is_action_pressed("ui_down"):
		self.position = self.position + Vector2(0,3)
	if Input.is_action_pressed("ui_right"):
		self.position = self.position + Vector2(3,0)
	if Input.is_action_pressed("ui_left"):
		self.position = self.position + Vector2(-3,0)
	pass


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			self.set_zoom(self.get_zoom() * 0.9)
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.set_zoom(self.get_zoom() * 1.1)
			
	
