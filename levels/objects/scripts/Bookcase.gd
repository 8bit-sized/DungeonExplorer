tool
extends StaticBody
class_name Bookcase

export (bool) var filled := false setget set_filled
export (bool) var broken := false setget set_broken

func _ready() -> void:
	switch_mesh()

func switch_mesh() -> void:
	$case.visible = not broken and not filled
	$broken.visible = broken and not filled
	$filled.visible = not broken and filled
	$broken_filled.visible = broken and filled

func set_filled(value: bool) -> void:
	filled = value
	switch_mesh()

func set_broken(value: bool) -> void:
	broken = value
	switch_mesh()
