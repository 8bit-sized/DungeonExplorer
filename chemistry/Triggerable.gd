extends Node
class_name Triggerable

#triggering could be an instant or continuous event
# effect should manage that? or do I need to emit a signal?

signal triggered(value)

enum TYPE {LEAF, AND, OR, NOT, SEQUENCE}

var _active := false #setget set_active, get_active
export  (TYPE) var type = TYPE.LEAF

var sub_triggers: Array = []
var sequence: Array = []

func _init() -> void:
	add_to_group("triggerable")

#load all children of type triggerable for AND, OR as I will use them to iterate and get active value
func _ready() -> void:
	for child in get_children():
		if child.is_in_group("triggerable") :
			child.connect("triggered", self, "_sub_trigger_updated", [sub_triggers.size()])
			sub_triggers.append(child)
		_active = get_active() # get initial state, useful when it is on from start (especially for NOT nodes)

func effect(value: bool) -> void:
	# it could be a single effect or turning process on with a timer or dependent on triggers conditions (flame will turn off on their own, but have no built in timer clock signal
	
	# to be used in root, or maybe I could chain triggers and effects this way?
	pass

func _sub_trigger_updated(value: bool, index: int = 0) -> void:
	if type == TYPE.SEQUENCE:
		if not value or sequence.size() >= sub_triggers.size():
			sequence = [] # if flames turns off, empty sequence without other reset
		if value:
			sequence.append(index)
	var is_active = get_active()
	set_active(is_active) #update state only if there's a change

func trigger_reset(value: bool) -> void:
	if not value and sequence.size() >= sub_triggers.size():
		yield(get_tree().create_timer(2.0), "timeout")
		for t in sub_triggers:
			t.set_active(false)

func set_active(new_value: bool) -> void:
	if new_value != _active:
		_active = new_value
		effect(_active)
		emit_signal('triggered', new_value)

func get_active() -> bool:
	if sub_triggers.size() <= 0:
		return false
	var res = false
	match type:
		TYPE.LEAF:
			res = _active
		TYPE.NOT:
			res = !sub_triggers[0].get_active()
		TYPE.OR: # res already false
			for trig in sub_triggers:
				res = res or trig.get_active()
		TYPE.AND, TYPE.SEQUENCE:
			res = true
			for trig in sub_triggers:
				res = res and trig.get_active()
			continue # sequence will fallthrough to next
		TYPE.SEQUENCE:
			res = res and (sequence == range(sub_triggers.size()))
			trigger_reset(res)
	return res
