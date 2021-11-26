extends Position3D
class_name SimpleCameraRig

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rotation = Input.get_axis('look_left','look_right')
	rotate_y(rotation * 0.1)
	
	var pitch = Input.get_axis('look_up', 'look_down')
	$Pitch.rotate_x(pitch * 0.1)
	
	# I need a control to toggle follow mode, that will be dismissed to pass in orbit mode when right stick x axis is moved
	# y axis should raise, lower camera and with a button pressed should zoom (while following a given path to harmonize the movement)
