extends Node2D

func _on_booster_time_pressed() -> void:
	Player.allow_bootser(true)

func _on_add_dust_pressed() -> void:
	Player.add_dust(50)

func _on_add_all_cards_pressed() -> void:
	Player.add_cards(_create_all())

func _on_clear_pressed() -> void:
	Player.burn_collection()

func _on_add_l_pressed() -> void:
	Player.add_cards(_create_all_suit(Card.SUIT.LIGHTNING))

func _on_add_w_pressed() -> void:
	Player.add_cards(_create_all_suit(Card.SUIT.WATER))

func _on_add_f_pressed() -> void:
	Player.add_cards(_create_all_suit(Card.SUIT.FIRE))

func _on_add_e_pressed() -> void:
	Player.add_cards(_create_all_suit(Card.SUIT.EARTH))

func _create_all_suit(suit: Card.SUIT) -> Array:
	var result = []
	for rank in Card.RANK:
		result.append(Card.create(suit, Card.RANK[rank]))
	return result
	
func _create_all() -> Array:
	var result = []
	for suit in Card.SUIT:
		for rank in Card.RANK:
			result.append(Card.create(Card.SUIT[suit], Card.RANK[rank]))
	return result

func _on_exit_pressed() -> void:
	visible = false
