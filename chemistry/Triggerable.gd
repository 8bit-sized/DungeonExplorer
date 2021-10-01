extends Node
class_name Triggerable

#triggering could be an instant or continuous event
# effect should manage that? or do I need to emit a signal?

enum TYPE {NONE, AND, OR, NOT}

var active := false setget set_active, get_active
export  (TYPE) var type = TYPE.NONE

var sub_triggers: Array = []

#load all children of type triggerable for AND, OR as I will use them to iterate and get active value
func _ready() -> void:
	pass
#	for child in get_children():
#		if child is Triggerable: # use a group instead of own name
#			sub_triggers.append(child)
	#I hope they stop at first generation children to ease multilevel triggering rules


func set_active(new_value: bool) -> void:
	if type == TYPE.NONE:
		active = new_value

func get_active() -> bool:
	match type:
		TYPE.NONE:
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
