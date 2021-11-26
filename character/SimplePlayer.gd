extends KinematicBody
class_name SimplePlayer

onready var character : BaseCharacter = $BaseCharacter
onready var camera_rig : SimpleCameraRig = $SimpleCameraRig

export (float) var gravity := -80.0 
export (float) var speed := 10.0

# add these when improve orbiting while moving
var input_direction : = Vector2.ZERO setget _set_input_direction
var forward := Vector3.ZERO
var right := Vector3.ZERO

var velocity := Vector3.ZERO
var target := Vector3(0,0,10)

func _ready() -> void:
	right = camera_rig.global_transform.basis.x
	forward = camera_rig.global_transform.basis.z
	
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var fall_velocity = velocity.y + gravity * delta # apply gravity
	self.input_direction = Input.get_vector('move_left','move_right', 'move_front', 'move_back')
	#var move_direction := Vector3(input_direction.x, 0, input_direction.y) 
	#var move_direction := camera_rig.global_transform.basis.x * input_direction.x + camera_rig.global_transform.basis.z * input_direction.y
	var move_direction := right * input_direction.x + forward * input_direction.y
	
	if move_direction.length() > 0.2:
		target = target.linear_interpolate(character.global_transform.origin - move_direction, 3.0*delta)
		character.look_at(target, Vector3.UP)
	
	velocity = move_direction * speed
	velocity.y = fall_velocity
	
	velocity = move_and_slide(velocity, Vector3.UP)
	

func _set_input_direction(value: Vector2) -> void:
	if input_direction == Vector2.ZERO:
		right = camera_rig.global_transform.basis.x
		forward = camera_rig.global_transform.basis.z
	input_direction = value
