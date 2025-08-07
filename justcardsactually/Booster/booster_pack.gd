extends StaticBody3D

class_name BoosterPack

enum TYPE { FREE, PAID, DISABLED }

@onready var pack = $Pack

var _type: TYPE = TYPE.FREE
@export var type: TYPE:
	get:
		return _type
	set(value):
		_type = value
		_update_for_type()

func _ready() -> void:
	_update_for_type()

func _update_for_type():
	print()
