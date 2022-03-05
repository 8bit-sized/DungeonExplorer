extends Position3D
class_name SimpleCameraRig

export (float, 0.01, 0.1) var controller_speed := 0.05

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var rotation = Input.get_axis('look_left','look_right')
	rotate_y(-rotation * controller_speed)
	
	var pitch = Input.get_axis('look_up', 'look_down')
	$Pitch.rotate_x(pitch * controller_speed)
