tool
extends Spatial #CharacterHead
class_name CharacterHead

export (Global.CHAR)  var type = Global.CHAR.SK_MINION setget set_type
export (bool) var broken = false setget set_broken

export (float, 0.0, 1.0, 0.1) var anger := 0.0 setget set_anger
export (float, 0.0, 1.0, 0.1) var happiness := 0.0 setget set_happiness
export (float, 0.0, 1.0, 0.1) var mouth := 0.0 setget set_mouth

onready var skull: MeshInstance = $SkullBone
onready var jaw: MeshInstance = $JawJoint/Jaw
onready var upper_accessory: MeshInstance = $Accessory/Upper
onready var lower_accessory: MeshInstance = $Accessory/Lower

var parts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parts = [{"name": "skull", "node": skull},
			{"name": "jaw", "node": jaw},
			{"name": "upper", "node": upper_accessory},
			{"name": "lower", "node": lower_accessory}]
	_update_looks()

func set_anger(value: float) -> void:
	anger = value
	$SkullBone.set('blend_shapes/Angry', anger)

func set_happiness(value: float) -> void:
	happiness = value
	$SkullBone.set('blend_shapes/Happy', happiness)

func set_mouth(value: float) -> void:
	$JawJoint.rotate_x((value - mouth)/5.8)
	mouth = value

func set_type(value: int) -> void:
	if value == type:
		return
	type = value
	_update_looks()

func set_broken(value: bool) -> void:
	if value == broken:
		return
	broken = value
	_update_looks()

func _update_looks() -> void:
	var broken_suffix = "_broken" if broken else ""
	var skull_type = ""
	upper_accessory.visible = false
	lower_accessory.visible = false
	var upper_name = "archer_hood"
	var lower_name = "archer_mask"
	
	match type:
		Global.CHAR.SK_ARCHER:
			upper_accessory.visible = true
			upper_name = "archer_hood"
			lower_accessory.visible = true
			lower_name = "archer_mask"
		Global.CHAR.SK_WARRIOR:
			upper_accessory.visible = true
			upper_name = "warrior_helmet"
		Global.CHAR.SK_MAGE:
			lower_accessory.visible = true
			lower_name = "mage_cowl"
			if broken:
				skull_type = "_mage" + broken_suffix
		_: #minion default
			if broken:
				skull_type = "_minion" + broken_suffix

	var skull_path = str('res://assets/kaykit/parts/skeleton_skull', skull_type ,'.tres')
	var jaw_path = str('res://assets/kaykit/parts/skeleton_jaw', broken_suffix ,'.tres')
	var upper_path = str('res://assets/kaykit/parts/skeleton_',upper_name, broken_suffix ,'.tres')
	var lower_path = str('res://assets/kaykit/parts/skeleton_', lower_name, '.tres')
	
	skull.mesh = load(skull_path)
	jaw.mesh = load(jaw_path)
	upper_accessory.mesh = load(upper_path)
	lower_accessory.mesh = load(lower_path)
		

