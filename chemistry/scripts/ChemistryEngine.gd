extends Spatial
class_name ChemistryEngine

# multiple fire presets to match shape of burnable object
var FlameScene = preload('res://chemistry/Flame.tscn')
var FlamePanelScene = preload('res://chemistry/FlamePanel.tscn')

func _ready() -> void:
	yield(get_tree().root, 'ready')
	add_to_group('chemistry_engine')
	var all_burnables = get_tree().get_nodes_in_group('burnable')
	for b in all_burnables:
		b.connect('start_fire', self, '_on_start_fire')

func _on_start_fire(area: Burnable) -> void:
	var new_flame: Flame
	match area.type:
		Burnable.TYPE.POINT:
			new_flame = FlameScene.instance()
		Burnable.TYPE.PANEL:
			new_flame = FlamePanelScene.instance()
	
	$Flames.add_child(new_flame)
	new_flame.burnable = area
	area.flame = new_flame
