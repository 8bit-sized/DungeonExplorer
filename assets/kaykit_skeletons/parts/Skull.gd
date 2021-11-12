tool
extends Spatial
class_name CharacterHead

enum TYPE {ARCHER, MAGE, MINION, WARRIOR}

export (TYPE) var type = TYPE.ARCHER
export (bool) var broken = false

export (float, 0.0, 1.0, 0.1) var anger := 0.0 setget set_anger
export (float, 0.0, 1.0, 0.1) var happiness := 0.0 setget set_happiness
export (float, 0.0, 1.0, 0.1) var mouth := 0.0 setget set_mouth

# list possible configurations for loading
# then put 2 or more and see if there are problems with exports...


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_anger(value: float) -> void:
	anger = value
	$SkullBone.set('blend_shapes/Angry', anger)

func set_happiness(value: float) -> void:
	happiness = value
	$SkullBone.set('blend_shapes/Happy', happiness)

func set_mouth(value: float) -> void:
	$JawJoint.rotate_x((value - mouth)/5.8)
	mouth = value

func set_type(value) -> void:
	type = value
