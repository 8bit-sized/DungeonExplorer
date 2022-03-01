tool
extends Spatial
class_name BaseCharacter

# Looks vars
export (Global.CHAR) var type = Global.CHAR.SK_MINION setget set_type
export (bool) var broken = false setget set_broken

onready var head: CharacterHead = $'KayKit Animated Character/Skeleton/Head/Head' # removed type for cyclic reference error on load
onready var body: MeshInstance = $'KayKit Animated Character/Skeleton/Body/Body'
onready var arm_left: MeshInstance = $'KayKit Animated Character/Skeleton/ArmLeft/Offset/ArmLeft'
onready var arm_right: MeshInstance = $'KayKit Animated Character/Skeleton/ArmRight/Offset/ArmRight'
onready var body_accessory : MeshInstance = $'KayKit Animated Character/Skeleton/Body/Offset/Accessory'

var parts = []

# Animation vars
enum Actions {IDLE, MOVE, AIR, FALL, WAVE} # let's consider states from a different perspective
var current_action = Actions.IDLE      # I could use a string

onready var _animation_tree := $AnimationTree
onready var _playback : AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var _velocity_buffer_size := 5
var _velocity_candidate := 0.0
var _velocity_count := 0

func _ready() -> void:
	parts = [{"name": "body", "node": body},
			{"name": "left_arm", "node": arm_left},
			{"name": "right_arm", "node": arm_right}]
	_update_looks()
	_animation_tree.active = true # make sure this is active


# Looks Functions

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
	#head.type = type # make another head file with some different controls from skull, replace broken with "variant" concept and make export work if the underlying control exists
	#head.broken = broken
	# skull should load a different subclass of head, but I need all controls on base character head with empty implementation for missing controls
	var type_name = ""
	var broken_suffix = "_broken" if broken else ""
	body_accessory.visible = false
	match type:
		Global.CHAR.SK_ARCHER:
			type_name = "skeleton_archer"
		Global.CHAR.SK_MINION:
			type_name = "skeleton_minion"
		Global.CHAR.SK_WARRIOR:
			type_name = "skeleton_warrior"
		Global.CHAR.SK_MAGE:
			type_name = "skeleton_mage"
			body_accessory.visible = true
			body_accessory.mesh = load('res://assets/kaykit/parts/cape_mage.tres')
		Global.CHAR.DGN_ROGUE:
			type_name = "dungeon_rogue"
			# add quiver as back accessory
		Global.CHAR.DGN_BARBARIAN:
			type_name = "dungeon_barbarian"
		Global.CHAR.DGN_MAGE:
			type_name = "dungeon_mage"
		Global.CHAR.DGN_KNIGHT:
			type_name = "dungeon_knight"
			# I may need to change the offsets if other objects are supported
	
	for part in parts:
		var path = str('res://assets/kaykit/parts/', type_name, '_', part["name"], broken_suffix ,'.tres')
		var mesh_instance: MeshInstance = part["node"]
		mesh_instance.mesh = load(path)

# Animation functions
func do_action(action: int, direction: Vector3 = Vector3.ZERO) -> void:
	#_animation_tree["parameters/MOVE/blend_position"] = round(direction.length())/10 # update before refusing to change animation
	buffer_velocity(direction.length())
	if current_action == action:
		return
	current_action = action
	var action_name = Actions.keys()[action]
	_playback.travel(action_name)

func buffer_velocity(new_velocity : float = 0.0) -> void:
	var rounded_velocity = round(new_velocity)/10
	if rounded_velocity != _velocity_candidate:
		_velocity_candidate = rounded_velocity
		_velocity_count = 1
	else:
		_velocity_count += 1
		if _velocity_count == _velocity_buffer_size: #changes only once signal is stable
			_animation_tree["parameters/MOVE/blend_position"] = rounded_velocity

# experiment to get current executing action by calling method with parameter in animation
func entered_state(state_name: String) -> void:
	#print("entered state: " + state_name)
	if state_name == "IDLE":
		current_action = 0 # find a better way to get the index
