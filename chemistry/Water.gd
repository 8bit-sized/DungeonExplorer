extends Area
class_name Water

# There are 3 possible "shapes" a body of water (lake, river, sea, pool), rain (an area with shader for looks)
# and "splash" of water if a break an object with water inside (to extinguish fire)

func _ready() -> void:
	add_to_group("water")
