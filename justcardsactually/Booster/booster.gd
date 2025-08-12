extends Node3D

class_name Booster

const booster_cards_scene = preload("res://Booster/BoosterCards/BoosterCards.tscn")
const MOVE_DURATION = 0.5

var opening = false
@onready var booster: BoosterPack = $BoosterPack
@onready var marker_start: Marker3D = $MarkerStart
@onready var marker_end: Marker3D = $MarkerEnd


func _ready() -> void:
	Player.dust_update.connect(_on_dust_updated)
	Player.booster_update.connect(_on_booster_updated)
	_update_booster()


func _hide():
	opening = false
	for n in get_children():
		if n != marker_start and n != marker_end:
			remove_child(n)


func _show():
	opening = false
	add_child(booster)
	booster.global_position = marker_start.global_position


func _end_booster():
	var tween := create_tween()
	tween.tween_property(booster, "global_position", marker_end.global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


func _start_booster():
	var tween := create_tween()
	tween.tween_property(booster, "global_position", marker_start.global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)


func _on_booster_updated():
	_update_booster()


func _on_dust_updated():
	_update_booster()


func _update_booster():
	if Player.booster_available:
		booster.type = BoosterPack.TYPE.FREE
	elif Player.dust_booster_available:
		booster.type = BoosterPack.TYPE.PAID
	else:
		booster.type = BoosterPack.TYPE.DISABLED


func _on_rotator_tap_detected() -> void:
	if booster.type != BoosterPack.TYPE.DISABLED and !opening:
		_open_booster()


func _open_booster():
	var cards = Player.generate_booster()
	opening = true
	SoundPlayer.play_sound(SoundPlayer.SOUND.BOOSTER_OPEN)
	await _end_booster()
	
	var booster_cards = booster_cards_scene.instantiate()
	booster_cards.cards = cards
	booster_cards.done.connect(_on_booster_cards_done)
	add_child(booster_cards)
	SoundPlayer.play_sound(SoundPlayer.SOUND.SHUFFLE)
	
	var is_free = booster.type == BoosterPack.TYPE.FREE
	Player.accept_booster(cards, 0 if is_free else Player.BOOSTER_COST, is_free)


func _on_booster_cards_done(node: Node3D) -> void:
	remove_child(node)
	opening = false
	_start_booster()
