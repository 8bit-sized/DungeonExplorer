extends Spatial
class_name ChemistryEngine

var FlameScene = preload('res://chemistry/Flame.tscn')

func _ready() -> void:
	yield(get_tree().root, 'ready')
	add_to_group('chemistry_engine')
	var all_burnables = get_tree().get_nodes_in_group('burnable')
	for b in all_burnables:
		b.connect('start_fire', self, '_on_start_fire')

func _on_start_fire(area: Burnable) -> void:
	var new_flame = FlameScene.instance()
	$Flames.add_child(new_flame)
	new_flame.burnable = area
	area.flame = new_flame
