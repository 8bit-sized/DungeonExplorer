extends Area
class_name PickHand

var picking := false # <- this should be a state
var pickable_object: Pickable = null 
var hand_ik: SkeletonIK # I need some kind of easy setup, but it must always be child of skeleton
var right_hand : Position3D 

# Throw
onready var anim_player := $AnimationPlayer
var strength := 0.0
export (float, 2.0, 10.0) var strength_speed = 5.0
export (float, 5.0, 20.0) var max_strength := 10.0

func _ready() -> void:
	yield(owner, "ready")
	var skeleton = get_parent()
#	add_to_group("picker")
	hand_ik = skeleton.get_node('HandRIK')
	right_hand = skeleton.get_node('HandRBone/Position3D')

func _process(delta: float) -> void:
	if pickable_object:
		if Input.is_action_pressed('fire'):
			# start strength, derive from movement speed
			strength = min(max_strength, strength + delta * strength_speed)
		elif Input.is_action_just_released('fire'):
			anim_player.play('throw')

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact') and pickable_object:
		picking = true
		pickable_object.get_picked_by(right_hand)
		pickable_object.highlight = false
		hand_ik.start()
		
	if event.is_action_pressed('fire') and pickable_object:
		anim_player.play('throw_charge')

func release_object() -> void:
	var dir := global_transform.basis.z.normalized() * strength + Vector3(0,5,0)
	pickable_object.get_thrown(dir)
	pickable_object = null 
	picking = false

func reset_hand() -> void:
	hand_ik.stop()
	strength = 0.0

func _on_PickHand_body_entered(body: Node) -> void:
	if picking:
		return
	# add animation for picking
	if body.is_in_group("pickable"):
		body.highlight = true
		pickable_object = body

func _on_PickHand_body_exited(body: Node) -> void:
	if body.is_in_group("pickable") and not picking:
		body.highlight = false
		pickable_object = null
