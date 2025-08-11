extends StaticBody3D

class_name BoosterPack

enum TYPE { FREE, PAID, DISABLED }

@onready var pack = $Pack
@onready var animation = $SubViewport/AnimatedSprite2D
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
	match type:
		TYPE.FREE:
			animation.play("default")
		TYPE.PAID:
			animation.play("pay")
		TYPE.DISABLED:
			animation.play("disabled")
