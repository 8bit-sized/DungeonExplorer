tool
extends Spatial
class_name BaseCharacter

# Looks vars

enum TYPE {SK_ARCHER, SK_MAGE, SK_MINION, SK_WARRIOR}

export (TYPE) var type = TYPE.SK_MINION setget set_type
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
	head.type = type
	head.broken = broken
	var type_name = ""
	var broken_suffix = "_broken" if broken else ""
	body_accessory.visible = false
	match type:
		TYPE.SK_ARCHER:
			type_name = "skeleton_archer"
		TYPE.SK_MINION:
			type_name = "skeleton_minion"
		TYPE.SK_WARRIOR:
			type_name = "skeleton_warrior"
		TYPE.SK_MAGE:
			type_name = "skeleton_mage"
			body_accessory.visible = true
			body_accessory.mesh = load('res://assets/kaykit/parts/cape_mage.tres')
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
