extends Triggerable
# Torch
# I don't need a class_name in this case

# Active derives directly from burnable node
# no need to set the value here


func set_active(new_value: bool) -> void:
	pass

func get_active() -> bool:
	return $Burnable.burning
