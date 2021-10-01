extends RigidBody
class_name Pickable

#export (NodePath) var target_path = null
var _target: Spatial = null

var highlight := false setget set_highlight
var mesh : Highlightable = null

func _ready() -> void:
	# set as pickable group
	add_to_group("pickable")
#	if target_path != null:
#		_target = get_node(target_path)
	
	for child in get_children():
		if child.is_in_group("highlightable"):
			mesh = child

func set_highlight(value: bool) -> void:
	highlight = value
	if mesh != null:
		mesh.highlight = highlight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _target != null:
		self.global_transform.origin = _target.global_transform.origin
		self.global_transform.basis = _target.global_transform.basis

func get_picked_by(picker: Spatial) -> void:
	_target = picker
	mode = MODE_KINEMATIC

func get_thrown(impulse: Vector3) -> void:
	#impulse (direction and strength)
	_target = null
	mode = MODE_RIGID
	apply_central_impulse(impulse)
