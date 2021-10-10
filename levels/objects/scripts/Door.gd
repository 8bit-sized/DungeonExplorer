extends Triggerable
class_name Door

onready var anim = $Door/AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.
	
func effect(value: bool) -> void:
	if value:
		anim.play('open')
	else:
		anim.play('close')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
