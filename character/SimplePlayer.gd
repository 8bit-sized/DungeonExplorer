extends KinematicBody
class_name SimplePlayer

onready var character : BaseCharacter = $BaseCharacter
onready var camera_rig : SimpleCameraRig = $SimpleCameraRig

export (float) var gravity := -80.0 
export (float) var speed := 10.0

var jump_impulse := 20.0
var velocity := Vector3.ZERO
var target := Vector3(0,0,10)

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var fall_velocity = velocity.y + gravity * delta # apply gravity
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		fall_velocity = jump_impulse
	
	
	var input_direction := Input.get_vector('move_left','move_right', 'move_front', 'move_back')
	#var move_direction := Vector3(input_direction.x, 0, input_direction.y) 
	var move_direction := camera_rig.global_transform.basis.x * input_direction.x + camera_rig.global_transform.basis.z * input_direction.y
	
	if move_direction.length() > 0.2:
		target = target.linear_interpolate(character.global_transform.origin - move_direction, 3.0*delta)
		#fix target height to avoid tilting of charcater in jump, slopes (could be removed if FSM, maybe...)
		target.y = character.global_transform.origin.y
		character.look_at(target, Vector3.UP)
	
	velocity = move_direction * speed
	velocity.y = fall_velocity
	
	velocity = move_and_slide(velocity, Vector3.UP)
