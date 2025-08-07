extends Node

const COLLECTION_KEY = "user_collection"
const DUST_KEY = "user_dust"
const LAST_BOOSTER_DATE_KEY = "last_booster_date"

const BOOSTER_SIZE = 5

const RARITY_COUNT = 1
const EXTRA_RARITY_COUNT = 1
const RARE_CHANCE = 1
const EPIC_CHANCE = 0.2
const LEGENDARY_CHANCE = 0.1
const EXTRA_RARE_CHANCE = 0.3
const EXTRA_EPIC_CHANCE = 0.1
const EXTRA_LEGENDARY_CHANCE = 0.05

const BOOSTER_COST = 50
const DUST_VALUE = {
	Card.LEVEL.COMMON: 3,
	Card.LEVEL.RARE: 10,
	Card.LEVEL.EPIC: 20,
	Card.LEVEL.LEGENDARY: 40
}

const COLLECTION_FULL_SIZE = 68

signal booster_update
signal collection_update
signal dust_update

var rng = RandomNumberGenerator.new()

var collection: Array
var dust: int
var booster_available: bool
var dust_booster_available: bool:
	get:
		return dust >= BOOSTER_COST

func _ready() -> void:
	Storage.load_from_cache()
	collection = Storage.get_value(COLLECTION_KEY, [])
	dust = Storage.get_value(DUST_KEY, 0)
	var last_bootser_date = Storage.get_value(LAST_BOOSTER_DATE_KEY)
	booster_available = last_bootser_date == null || _compare_dates(last_bootser_date, Time.get_date_dict_from_system())


# logic


func get_formatted_collection() -> Dictionary:
	var sort_f = func (card1, card2):
		return card1.rank < card2.rank
	
	var filter_l_f = func (card):
		return card.suit == Card.SUIT.LIGHTNING
	var filter_w_f = func (card):
		return card.suit == Card.SUIT.WATER
	var filter_f_f = func (card):
		return card.suit == Card.SUIT.FIRE
	var filter_e_f = func (card):
		return card.suit == Card.SUIT.EARTH
	
	var dict = {
		Card.SUIT.LIGHTNING: collection.filter(filter_l_f),
		Card.SUIT.WATER: collection.filter(filter_w_f),
		Card.SUIT.FIRE: collection.filter(filter_f_f),
		Card.SUIT.EARTH: collection.filter(filter_e_f)
	}
	
	for c in dict:
		c.sort_custom(sort_f)
	
	return dict


func generate_booster() -> Array:
	var booster = []
	for i in range(0, RARITY_COUNT):
		var r = rng.randf()
		if r <= LEGENDARY_CHANCE:
			booster.append(_generate_card(Card.LEVEL.LEGENDARY))
		elif r <= EPIC_CHANCE:
			booster.append(_generate_card(Card.LEVEL.EPIC))
		elif r <= RARE_CHANCE:
			booster.append(_generate_card(Card.LEVEL.RARE))
	
	for i in range(0, EXTRA_RARITY_COUNT):
		var r = rng.randf()
		if r <= EXTRA_LEGENDARY_CHANCE:
			booster.append(_generate_card(Card.LEVEL.LEGENDARY))
		elif r <= EXTRA_EPIC_CHANCE:
			booster.append(_generate_card(Card.LEVEL.EPIC))
		elif r <= EXTRA_RARE_CHANCE:
			booster.append(_generate_card(Card.LEVEL.RARE))
	
	for i in range(0, BOOSTER_SIZE - booster.size()):
		booster.append(_generate_card(Card.LEVEL.COMMON))
	
	return booster


func should_dust_card(card: Card) -> int:
	var eq_f = func (card2):
		return card.eq(card2)
	if collection.find_custom(eq_f) != -1:
		return DUST_VALUE[card.level]
	else:
		return -1


func accept_booster(cards: Array, spent_dust: int, is_free: bool):
	var filtered_cards = []
	var dust_diff = -spent_dust
	
	for c in cards:
		var card = c as Card
		var dust = should_dust_card(card)
		if dust == -1:
			filtered_cards.append(card)
		else:
			dust_diff += dust
	
	_mutate(is_free, filtered_cards, dust_diff)


func _generate_card(level: Card.LEVEL) -> Card:
	var suit = Card.SUIT.values().pick_random() # ??
	var rank = Card.ranks_for_level(level).pick_random()
	var card = Card.create(suit, rank)
	return card


# mutations


func _mutate(is_free: bool, cards: Array, dust_diff: int):
	var filter_f = func (card):
		var eq_f = func (card2):
			return card.eq(card2)
		return collection.find_custom(eq_f) == -1
	cards = cards.filter(filter_f)
	collection.append_array(cards)
	Storage.set_value(COLLECTION_KEY, collection)
	if !cards.is_empty():
		collection_update.emit()

	dust += dust_diff
	Storage.set_value(DUST_KEY, dust)
	if dust_diff != 0:
		dust_update.emit()
	
	if is_free:
		booster_available = false
		Storage.set_value(LAST_BOOSTER_DATE_KEY, Time.get_date_dict_from_system())
		booster_update.emit()
	
	Storage.save_to_cache()


func add_cards(cards: Array):
	_mutate(false, cards, 0)


func add_dust(count: int):
	dust += count
	Storage.set_value(DUST_KEY, dust)
	Storage.save_to_cache()
	
	dust_update.emit()


func allow_bootser(allow: bool):
	booster_available = allow
	Storage.set_value(LAST_BOOSTER_DATE_KEY, null if allow else Time.get_date_dict_from_system())
	Storage.save_to_cache()
	
	booster_update.emit()

func burn_collection():
	collection = []
	dust = 0
	booster_available = true
	Storage.clear_cache()
	Storage.save_to_cache()
	
	collection_update.emit()
	dust_update.emit()
	booster_update.emit()


# helpers


func _compare_dates(date1, date2) -> bool:
	return date1["year"] < date2["year"] || date1["month"] < date2["month"] || date1["day"] < date2["day"]
