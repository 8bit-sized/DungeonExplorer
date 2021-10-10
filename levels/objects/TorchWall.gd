extends Triggerable
class_name TorchWall

func _process(delta: float) -> void:
	set_active($Burnable.burning)

func get_active() -> bool:
	return $Burnable.burning
