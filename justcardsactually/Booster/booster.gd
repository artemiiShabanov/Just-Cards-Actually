extends Node3D

class_name Booster

const booster_cards_scene = preload("res://Booster/BoosterCards/BoosterCards.tscn")

var opening = false
@onready var booster: BoosterPack = $BoosterPack
@onready var rotator = $Rotator


func _ready() -> void:
	Player.dust_update.connect(_on_dust_updated)
	Player.booster_update.connect(_on_booster_updated)
	_update_booster()


func _hide():
	for n in get_children():
		remove_child(n)


func _show():
	add_child(booster)


func _update():
	if opening:
		remove_child(booster)
	else:
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
	if booster.type != BoosterPack.TYPE.DISABLED:
		_open_booster()


func _open_booster():
	var cards = Player.generate_booster()
	opening = true
	_update()
	
	var booster_cards = booster_cards_scene.instantiate()
	booster_cards.cards = cards
	booster_cards.done.connect(_on_booster_cards_done)
	add_child(booster_cards)
	
	var is_free = booster.type == BoosterPack.TYPE.FREE
	Player.accept_booster(cards, 0 if is_free else Player.BOOSTER_COST, is_free)


func _on_booster_cards_done(node: Node3D) -> void:
	remove_child(node)
	opening = false
	_update()
