extends Node3D

class_name Collection

const card_scene = preload("res://Card/CardNode.tscn")
const PAGE_SIZE = 9

var collection: Array
var current_page: int = 0
var selected_index: int = -1
var pages_count: int

@onready var left_button: Button = $CanvasLayer/LeftButton
@onready var right_button: Button = $CanvasLayer/RightButton

var cards: Array

func _ready() -> void:
	Player.collection_update.connect(_on_collection_updated)
	
	collection = Player.collection
	var count = collection.size()
	pages_count = ceil(count / PAGE_SIZE)
	
	_update_buttons()
	_update_cards()

func _hide():
	selected_index = -1
	left_button.hide()
	right_button.hide()
	_clear_cards()
	_update_buttons()
	
func _show():
	left_button.show()
	right_button.show()
	_update_cards()
	_update_buttons()
	

func _disable_buttons():
	left_button.disabled = true
	right_button.disabled = true


func _update_buttons():
	left_button.disabled = current_page <= 0
	right_button.disabled = current_page >= pages_count


func _clear_cards():
	for card in cards:
		(card as Node3D).queue_free()
	cards.clear()
	

func _update_cards():
	_clear_cards()
	for i in range(0, min(PAGE_SIZE, collection.size() - PAGE_SIZE * current_page)):
		var index = PAGE_SIZE * current_page + i
		var card_data = collection[index]
		print(typeof(card_data))
		var card_node = card_scene.instantiate()
		card_node.rank = Card.RANK.ONE
		card_node.suit = Card.SUIT.WATER
		card_node.tapped.connect(_handle_tap)
		cards.append(card_node)
		add_child(card_node)


func _handle_tap(node):
	var index = cards.find(node)
	if selected_index == -1:
		_move_to_front(index)
		selected_index = index
	else:
		_move_to_back()
		selected_index = -1


func _move_to_front(index: int):
	_disable_buttons()
	

func _move_to_back():
	_update_buttons()


func _on_collection_updated():
	get_tree().reload_current_scene()


func _on_left_button_pressed() -> void:
	current_page -= 1
	_update_cards()
	_update_buttons()


func _on_right_button_pressed() -> void:
	current_page += 1
	_update_cards()
	_update_buttons()
