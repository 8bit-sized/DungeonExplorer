extends Area
class_name Burnable

signal start_fire(on_object)
signal burnt_down

export var burning := false setget set_burning
export (bool) var permanent := false
export (float) var max_seconds := 30.0 

var elapsed_seconds := 0.0
var flame: Flame = null # reference to the flame (so I can remove it when no more energy)

func _ready() -> void:
	add_to_group("burnable")

func _process(delta: float) -> void:
	if not burning:
		return
	if flame == null:
		emit_signal('start_fire', self)
	if permanent:
		return
	elapsed_seconds += delta
	if elapsed_seconds >= max_seconds:
		emit_signal('burnt_down')
		set_burning(false)

func set_burning(value: bool) -> void:
	if value == burning:
		return
	burning = value
	if burning:
		elapsed_seconds = 0.0
	else:
		flame.die() # it will take care of animations
		flame = null
