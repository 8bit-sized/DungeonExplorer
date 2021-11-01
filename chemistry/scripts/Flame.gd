extends Area
class_name Flame

var burnable: Area = null

func _ready() -> void:
	add_to_group("flame")
	randomize()

func _process(delta: float) -> void:
	$OmniLight.light_energy = rand_range(0.9, 1.5)
	
	if burnable != null: 
		self.global_transform.origin = burnable.global_transform.origin

func die() -> void:
	print("Flame dies")
	# play animation, sound...
	queue_free()


func _on_Flame_area_entered(area: Area) -> void:
	if area.is_in_group("burnable"):
		area.burning = true
	if area.is_in_group("water") and burnable != null:
		print("Flame in water")
		burnable.burning = false 
