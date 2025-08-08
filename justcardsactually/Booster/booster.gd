extends Node3D

class_name Booster

@onready var booster: BoosterPack = $BoosterPack
@onready var rotator = $Rotator

func _ready() -> void:
	Player.dust_update.connect(_on_dust_updated)
	Player.booster_update.connect(_on_booster_updated)
	_update_booster()


func _hide():
	remove_child(booster)
	
func _show():
	add_child(booster)

func _on_booster_updated():
	_update_booster()

func _on_dust_updated():
	_update_booster()
	
func _update_booster():
	if Player.booster_available:
		booster.visible = true
		booster.type = BoosterPack.TYPE.FREE
	elif Player.dust_booster_available:
		booster.visible = true
		booster.type = BoosterPack.TYPE.PAID
	else:
		booster.visible = false
		booster.type = BoosterPack.TYPE.DISABLED

func _on_rotator_tap_detected() -> void:
	print("tap")
