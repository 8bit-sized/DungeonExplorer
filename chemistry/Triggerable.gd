extends Node
class_name Triggerable

#triggering could be an instant or continuous event
# effect should manage that? or do I need to emit a signal?

signal triggered(value)

enum TYPE {LEAF, AND, OR, NOT}

var active := false setget set_active, get_active
export  (TYPE) var type = TYPE.LEAF

var sub_triggers: Array = []

func _init() -> void:
	add_to_group("triggerable")

#load all children of type triggerable for AND, OR as I will use them to iterate and get active value
func _ready() -> void:
	for child in get_children():
		if child.is_in_group("triggerable") :
			print(name + " -> " + child.name)
			child.connect("triggered", self, "_sub_trigger_updated")
			sub_triggers.append(child)
	#I hope they stop at first generation children to ease multilevel triggering rules

func effect(value: bool) -> void:
	# it could be a single effect or turning process on with a timer or dependent on triggers conditions (flame will turn off on their own, but have no built in timer clock signal
	
	# to be used in root, or maybe I could chain triggers and effects this way?
	pass

func _sub_trigger_updated(value: bool) -> void:
	var is_active = self.active
	effect(is_active)
#	emit_signal('triggered', is_active)

# I may add a reset, useful for timer effects where I want to reset all triggers
# I need to be careful to avoid loops, probably I should avoid setters and getters and just use func
# that way I will have no ambiguity

func set_active(new_value: bool) -> void:
	if type == TYPE.LEAF and new_value != active:
		print(name + " changed state: "+ str(new_value))
		active = new_value
		emit_signal('triggered', new_value)

func get_active() -> bool:
	match type:
		TYPE.LEAF:
			return active
		TYPE.NOT:
			if sub_triggers.size() <= 0:
				return false
			return !sub_triggers[0].active
		TYPE.AND:
			if sub_triggers.size() <= 0:
				return false
			var res = true
			for trig in sub_triggers:
				res = res and trig.active
			return res
		TYPE.OR:
			if sub_triggers.size() <= 0:
				return false
			var res = false
			for trig in sub_triggers:
				res = res or trig.active
			return res
	return false
