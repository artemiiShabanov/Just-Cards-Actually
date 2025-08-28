extends StaticBody3D

class_name BoosterPack

enum TYPE { FREE, PAID, DISABLED }

@onready var pack = $Pack
@onready var animation = $SubViewport/AnimatedSprite2D
@onready var timer_label = $SubViewport/MarginContainer/TimerLabel

var _type: TYPE = TYPE.FREE
@export var type: TYPE:
	get:
		return _type
	set(value):
		_type = value
		_update_for_type()

var time_left = 0

func _ready() -> void:
	time_left = Player.time_to_booster
	Player.booster_update.connect(_on_booster_updated)
	_update_for_type()

func _update_for_type():
	match type:
		TYPE.FREE:
			animation.play("default")
			timer_label.visible = false
		TYPE.PAID:
			animation.play("pay")
			timer_label.visible = false
		TYPE.DISABLED:
			animation.play("disabled")
			timer_label.visible = true

func _on_booster_updated():
	time_left = Player.time_to_booster
	update_timer()

func update_timer():
	timer_label.text = unix_time_to_string(time_left)

func unix_time_to_string(unix_time: int) -> String:
	var hours = int(unix_time / 3600) % 24
	var minutes = int((unix_time % 3600) / 60)
	var seconds = int(unix_time % 60)

	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func _on_timer_timeout() -> void:
	time_left -= 1
	update_timer()
