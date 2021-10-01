extends MeshInstance
class_name Highlightable

const active_uniform := 'active' # as in shader code

export (bool) var highlight := false setget set_highlight
#export (Color) var highlight_color := Color(0.9, 1.0, 0.9) 

var surface_count := 0

func _ready() -> void:
	add_to_group("highlightable") # if I ever need to turn all on/off
	surface_count = self.mesh.get_surface_count()
	_set_shader_parameter(active_uniform, 0.0)

func _set_shader_parameter(name: String, value: float) -> void:
	for i in range(0, surface_count):
		var material := self.mesh.surface_get_material(i)
		material.next_pass.set('shader_param/'+name, value)

func set_highlight(value: bool) -> void:
	highlight = value
	var uniform_value = 1.0 if highlight else 0.0
	_set_shader_parameter(active_uniform, uniform_value)
