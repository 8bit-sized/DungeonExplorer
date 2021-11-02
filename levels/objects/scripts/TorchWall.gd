extends Triggerable
class_name TorchWall

func effect(value: bool) -> void:
	if not value:
		$Burnable.burning = false

func _on_Burnable_start_fire(on_object) -> void:
	set_active(true)

func _on_Burnable_burnt_down() -> void:
	set_active(false)
