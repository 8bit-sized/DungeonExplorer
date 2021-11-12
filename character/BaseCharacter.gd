tool
extends Spatial
class_name BaseCharacter

enum TYPE {ARCHER, MAGE, MINION, WARRIOR}

export (TYPE) var type = TYPE.ARCHER setget set_type
export (bool) var broken = false

# mesh instances (or else like head)
onready var head: CharacterHead = $'KayKit Animated Character/Skeleton/Head/Head'
onready var body: MeshInstance = $'KayKit Animated Character/Skeleton/Body/Body'
onready var arm_left: MeshInstance = $'KayKit Animated Character/Skeleton/ArmLeft/Offset/ArmLeft'
onready var arm_right: MeshInstance = $'KayKit Animated Character/Skeleton/ArmRight/Offset/ArmRight'

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_type(value: int) -> void:
	if value == type:
		return
	type = value
	match type:
		TYPE.ARCHER:
			body.mesh = load('res://assets/kaykit_skeletons/parts/archer_body.tres')
		TYPE.MAGE:
			body.mesh = load('res://assets/kaykit_skeletons/parts/mage_body.tres')
		TYPE.MINION:
			body.mesh = load('res://assets/kaykit_skeletons/parts/minion_body.tres')
		TYPE.WARRIOR:
			body.mesh = load('res://assets/kaykit_skeletons/parts/warrior_body.tres')
		_:
			body.mesh = load('res://assets/kaykit_skeletons/parts/minion_body.tres')
