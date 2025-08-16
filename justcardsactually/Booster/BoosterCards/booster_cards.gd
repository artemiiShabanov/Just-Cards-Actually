extends Node3D

class_name BoosterCards

signal done(node: Node3D)

const MOVE_DURATION = 0.1
const HIDE_DURATION = 0.2
const card_scene = preload("res://Card/CardNode.tscn")
const explosion_scene = preload("res://Common/Explosion.tscn")

@onready var marker_front: Marker3D = $FrontMarker
@onready var marker_start: Marker3D = $StartMarker0
@onready var marker_finish: Marker3D = $FinishMarker
@onready var markers_start: Array =[$StartMarker1, $StartMarker2, $StartMarker3, $StartMarker4, $StartMarker5]

var cards: Array
var card_nodes: Array
var current_index: int = 0
var showed: Array
var busy = false

func _ready() -> void:
	_update_cards()
	_spread()


func _update_cards():
	for i in range(0, cards.size()):
		var card_data = cards[i] as Card
		var card_node = card_scene.instantiate()
		card_node.rank = card_data.rank
		card_node.suit = card_data.suit
		card_node.dustable = Player.should_dust_card(card_data) > 0
		card_node.tapped.connect(_handle_tap)
		card_nodes.append(card_node)
		add_child(card_node)
		card_node.global_position = marker_start.global_position

func _handle_tap(node: CardNode):
	var index = card_nodes.find(node)
	if !showed.has(index) and !busy:
		busy = true
		showed.append(index)
		
		if node.dustable:
			Input.vibrate_handheld(100, 0.4)
			await _dust_card(node)
		else:
			Input.vibrate_handheld(100, 0.2)
			await _hide_card(index)
		
		if showed.size() >= Player.BOOSTER_SIZE:
			done.emit(self)
		else:
			_move_to_front(index + 1)
		
		busy = false


func _hide_card(index: int):
	SoundPlayer.play_sound(SoundPlayer.SOUND.CARD_SLIDE)
	var card_node: Node3D = card_nodes[index]
	var tween := create_tween()
	tween.tween_property(card_node, "global_position", marker_finish.global_position, HIDE_DURATION).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


func _dust_card(card_node: CardNode):
	SoundPlayer.play_sound(SoundPlayer.SOUND.DUST)
	var e = explosion_scene.instantiate()
	add_child(e)
	e.global_position = card_node.global_position
	e.global_rotation = card_node.global_rotation
	e.emitting = true
	remove_child(card_node)
	await get_tree().create_timer(0.3).timeout

func _move_to_front(index: int):
	if index >= card_nodes.size():
		return
	var card_node = card_nodes[index] as Node3D
	var tween := create_tween()
	tween.tween_property(card_node, "global_position", marker_front.global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)
	

func _spread():
	for i in range(0, card_nodes.size()):
		var card_node = card_nodes[i] as Node3D
		var tween := create_tween()
		Input.vibrate_handheld(30, 0.6)
		tween.tween_property(card_node, "global_position", (markers_start[i] as Marker3D).global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
