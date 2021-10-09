extends Triggerable
class_name Reaction

# add reference to trigger node

func _ready() -> void:
	pass # Replace with function body.
	
func effect(value: bool) -> void:
	var rotation = -1.5 if value else 1.5
	$door.rotate_y(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
