extends Node3D

class_name BoosterCards

signal done(node: Node3D)

const MOVE_DURATION = 0.1
const SHOW_DURATION = 0.2
const card_scene = preload("res://Card/CardNode.tscn")

@onready var marker_front: Marker3D = $FrontMarker
@onready var marker_start: Marker3D = $StartMarker0
@onready var marker_finish: Marker3D = $FinishMarker
@onready var markers_start: Array =[$StartMarker1, $StartMarker2, $StartMarker3, $StartMarker4, $StartMarker5]
@onready var markers: Array =[$Marker1, $Marker2, $Marker3, $Marker4, $Marker5]
@onready var done_button: Button = $CanvasLayer/DoneButton

var cards: Array
var card_nodes: Array
var selected_index: int = -1
var showed: Array


func _ready() -> void:
	_update_cards()
	_update_done_button()
	_spread()


func _update_cards():
	for i in range(0, cards.size()):
		var card_data = cards[i] as Card
		var card_node = card_scene.instantiate()
		card_node.rank = card_data.rank
		card_node.suit = card_data.suit
		card_node.tapped.connect(_handle_tap)
		card_nodes.append(card_node)
		add_child(card_node)
		card_node.global_position = marker_start.global_position

func _handle_tap(node):
	var index = card_nodes.find(node)
	if showed.has(index):
		if selected_index == -1:
			_move_to_front(index)
			selected_index = index
		else:
			_move_to_back()
			selected_index = -1
	else:
		_show_card(index)
		showed.append(index)
		_update_done_button()


func _show_card(index: int):
	var card_node: Node3D = card_nodes[index]
	var marker: Marker3D = markers[index]
	var tween := create_tween()
	tween.tween_property(card_node, "global_position", marker.global_position, SHOW_DURATION).set_ease(Tween.EASE_IN_OUT)


func _update_done_button():
	done_button.visible = showed.size() == Player.BOOSTER_SIZE


func _move_to_front(index: int):
	var card_node = card_nodes[index] as Node3D
	var tween := create_tween()
	tween.tween_property(card_node, "global_position", marker_front.global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)
	

func _move_to_back():
	var card_node = card_nodes[selected_index] as Node3D
	var marker = markers[selected_index] as Node3D
	var tween := create_tween()
	tween.tween_property(card_node, "global_position", marker.global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)


func _spread():
	for i in range(0, card_nodes.size()):
		var card_node = card_nodes[i] as Node3D
		var tween := create_tween()
		tween.tween_property(card_node, "global_position", (markers_start[i] as Marker3D).global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)
		await tween.finished

func _collect():
	for i in range(0, card_nodes.size()):
		var card_node = card_nodes[i] as Node3D
		var tween := create_tween()
		tween.tween_property(card_node, "global_position", marker_finish.global_position, MOVE_DURATION).set_ease(Tween.EASE_IN_OUT)
		await tween.finished


func _on_done_button_pressed() -> void:
	done_button.visible = false
	await _collect()
	done.emit(self)
