extends Spatial
class_name Reaction

# add reference to trigger node

func _ready() -> void:
	pass # Replace with function body.

func effect() -> void:
	$door.rotate_y(-1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
