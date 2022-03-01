tool
extends Spatial
class_name CharHead


export (Global.CHAR)  var type = Global.CHAR.DGN_ROGUE setget set_type
#export (bool) var broken = false setget set_broken

export (int, 0, 3, 1) var variant := 0 setget set_variant

export (float, 0.0, 1.0, 0.1) var anger := 0.0 setget set_anger
export (float, 0.0, 1.0, 0.1) var happiness := 0.0 setget set_happiness
export (float, 0.0, 1.0, 0.1) var motion := 0.0 setget set_motion

onready var main: MeshInstance = $Main
onready var moving_part: MeshInstance = $MovingJoint/Moving
onready var upper_accessory: MeshInstance = $Accessory/Upper
onready var lower_accessory: MeshInstance = $Accessory/Lower

var parts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().root, "ready")
	parts = [{"name": "head", "node": main},
			{"name": "visor", "node": moving_part},
			{"name": "upper", "node": upper_accessory},
			{"name": "lower", "node": lower_accessory}]
	_update_looks()

func set_anger(value: float) -> void:
	pass

func set_happiness(value: float) -> void:
	pass

func set_motion(value: float) -> void:
	$MovingJoint.rotate_x((value - motion)/5.8)#remap acording to character
	motion = value

func set_type(value: int) -> void:
	if value == type:
		return
	type = value
	_update_looks()
	print("Changed type")

func set_variant(value: int) -> void:
	if variant == value:
		return
	variant = value
	_update_looks()
	print("Changed variant")

func _update_looks() -> void:
	var variant_suffix := "_d"
	var broken_suffix = "_broken" if variant != 0 else ""
	match variant: 
		1: 
			variant_suffix = "_a"
		2: 
			variant_suffix = "_b"
		3: 
			variant_suffix = "_c"
		_:
			variant_suffix = "_d"
	
	var type_name = ""
	moving_part.visible = false
	$MovingJoint.transform.origin.y = 0.259 # jaw default
	$MovingJoint.transform.origin.z = 0.082
	upper_accessory.visible = false
	upper_accessory.transform.origin.y = 0.0
	upper_accessory.transform.origin.z = 0.0
	lower_accessory.visible = false
	var main_name := "skeleton_skull"
	var moving_name := str("skeleton_jaw", broken_suffix) # jaw for skeletons
	var upper_name := "_hat" # skeletons
	var lower_name := "_hair"+ variant_suffix
	
	match type:
		Global.CHAR.DGN_BARBARIAN:
			type_name = "dungeon_barbarian"
			main_name = type_name + "_head"
			upper_accessory.transform.origin.y = 0.769
			upper_accessory.transform.origin.z = -0.073
			upper_accessory.visible = true
		Global.CHAR.DGN_ROGUE:
			type_name = "dungeon_rogue"
			main_name = type_name + "_head"
			lower_accessory.visible = true
		Global.CHAR.DGN_MAGE:
			type_name = "dungeon_mage"
			main_name = type_name + "_head"
			lower_accessory.visible = true
			upper_accessory.visible = true
			upper_accessory.transform.origin.y = 0.774
			upper_accessory.transform.origin.z = -0.016
		Global.CHAR.DGN_KNIGHT:
			type_name = "dungeon_knight"
			main_name = type_name + "_head"
			lower_accessory.visible = true
			moving_name = type_name + "_visor"
			moving_part.visible = true
			$MovingJoint.transform.origin.y = 0.259 # jaw default
			$MovingJoint.transform.origin.z = 0.082
			upper_accessory.visible = true
			upper_name = "_helmet"
			upper_accessory.transform.origin.y = 0.543
			upper_accessory.transform.origin.z = -0.013
		# skull parts loading can be performed in the base class, offset and behavior will change in subclass (remember to load eyes)
		Global.CHAR.SK_ARCHER:
			variant_suffix = ""
			type_name = "skeleton_archer"
			moving_part.visible = true
			upper_accessory.visible = true
			upper_name = "_hood" + broken_suffix
			lower_accessory.visible = true
			lower_name = "_mask"
		Global.CHAR.SK_WARRIOR:
			variant_suffix = ""
			type_name = "skeleton_warrior"
			moving_part.visible = true
			upper_accessory.visible = true
			upper_name = "_helmet" + broken_suffix
		Global.CHAR.SK_MAGE:
			variant_suffix = ""
			type_name = "skeleton_mage"
			moving_part.visible = true
			lower_accessory.visible = true
			lower_name = "_cowl"
			if variant != 0:
				main_name += "_mage_broken"
		Global.CHAR.SK_MINION:
			variant_suffix = ""
			type_name = "skeleton_minion"
			moving_part.visible = true
			if variant != 0:
				main_name += "_minion_broken"
		_: # other characters 
			pass
		

	var main_path = str('res://assets/kaykit/parts/', main_name, variant_suffix ,'.tres')
	var moving_path = str('res://assets/kaykit/parts/', moving_name, '.tres')
	var upper_path = str('res://assets/kaykit/parts/', type_name, upper_name ,'.tres')
	var lower_path = str('res://assets/kaykit/parts/', type_name, lower_name, '.tres')
	
	main.mesh = load(main_path)
	if moving_part.visible:
		moving_part.mesh = load(moving_path)
	if upper_accessory.visible:
		upper_accessory.mesh = load(upper_path)
	if lower_accessory.visible:
		lower_accessory.mesh = load(lower_path)
		

