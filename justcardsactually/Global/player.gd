extends Node

const DUST_KEY = "user_dust"
const LAST_BOOSTER_DATE_KEY = "last_booster_date"

const BOOSTER_SIZE = 5

const RARITY_COUNT = 1
const EXTRA_RARITY_COUNT = 1
const RARE_CHANCE = 1
const EPIC_CHANCE = 0.2
const LEGENDARY_CHANCE = 0.05
const EXTRA_RARE_CHANCE = 0.4
const EXTRA_EPIC_CHANCE = 0.1
const EXTRA_LEGENDARY_CHANCE = 0.02

const SECS_PER_DAY: int = 24 * 60 * 60

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
var time_to_booster: int
var dust_booster_available: bool:
	get:
		return dust >= BOOSTER_COST

func _ready() -> void:
	Storage.load_from_cache()
	collection = Storage.get_collection()
	dust = Storage.get_value(DUST_KEY, 0)
	_update_timer()

func _update_timer():
	var last_bootser_sec = Storage.get_value(LAST_BOOSTER_DATE_KEY)
	if last_bootser_sec == null:
		last_bootser_sec = 0.0
	var next_bootser_sec = _get_next_day(last_bootser_sec)
	var now_sec = Time.get_unix_time_from_system()
	time_to_booster = next_bootser_sec - now_sec
	booster_available = time_to_booster <= 0


func _get_next_day(sec: float) -> float:
	var next_day_sec = sec + SECS_PER_DAY + Time.get_time_zone_from_system().bias * 60
	var date = Time.get_datetime_dict_from_unix_time(next_day_sec)
	date["hour"] = 0
	date["minute"] = 0
	date["second"] = 0
	next_day_sec = Time.get_unix_time_from_datetime_dict(date)
	next_day_sec -= Time.get_time_zone_from_system().bias * 60
	return next_day_sec

# logic


func generate_booster(is_free: bool) -> Array:
	var booster = []
	for i in range(0, RARITY_COUNT):
		var r = rng.randf()
		if r <= LEGENDARY_CHANCE:
			booster.append(_generate_card(Card.LEVEL.LEGENDARY, booster))
		elif r <= EPIC_CHANCE:
			booster.append(_generate_card(Card.LEVEL.EPIC, booster))
		elif r <= RARE_CHANCE:
			booster.append(_generate_card(Card.LEVEL.RARE, booster))
	
	for i in range(0, EXTRA_RARITY_COUNT):
		var r = rng.randf()
		if r <= EXTRA_LEGENDARY_CHANCE:
			booster.append(_generate_card(Card.LEVEL.LEGENDARY, booster))
		elif r <= EXTRA_EPIC_CHANCE:
			booster.append(_generate_card(Card.LEVEL.EPIC, booster))
		elif r <= EXTRA_RARE_CHANCE:
			booster.append(_generate_card(Card.LEVEL.RARE, booster))
	
	if !is_free and collection.size() < COLLECTION_FULL_SIZE:
		while true:
			var suit = Card.SUIT.values().pick_random()
			var rank = Card.RANK.values().pick_random()
			var new_card = Card.create(suit, rank)
			if should_dust_card(new_card) < 0:
				booster.append(new_card)
				break
	
	for i in range(0, BOOSTER_SIZE - booster.size()):
		booster.append(_generate_card(Card.LEVEL.COMMON, booster))
	booster.reverse()
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
		var _dust = should_dust_card(card)
		if _dust == -1:
			filtered_cards.append(card)
		else:
			dust_diff += _dust
	
	_mutate(is_free, filtered_cards, dust_diff)


func _generate_card(level: Card.LEVEL, exclude: Array) -> Card:
	while true:
		var suit = Card.SUIT.values().pick_random()
		var rank = Card.ranks_for_level(level).pick_random()
		var card = Card.create(suit, rank)
		var good = true
		for e_card in exclude:
			if e_card.description == card.description:
				good = false
				break
		if good:
			return card
	return null


# mutations


func _mutate(is_free: bool, cards: Array, dust_diff: int):
	var filter_f = func (card):
		var eq_f = func (card2):
			return card.eq(card2)
		return collection.find_custom(eq_f) == -1
	
	cards = cards.filter(filter_f)
	if !cards.is_empty():
		var sort_f = func (card1, card2):
			return card1.suit < card2.suit || card1.suit == card2.suit && card1.rank < card2.rank
		collection.append_array(cards)
		collection.sort_custom(sort_f)
		Storage.set_collection(collection)
		collection_update.emit()

	if dust_diff != 0:
		dust += dust_diff
		Storage.set_value(DUST_KEY, dust)
		dust_update.emit()
	
	if is_free:
		print(Time.get_datetime_dict_from_system())
		Storage.set_value(LAST_BOOSTER_DATE_KEY, Time.get_unix_time_from_system())
		_update_timer()
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
	Storage.set_value(LAST_BOOSTER_DATE_KEY, 0.0 if allow else Time.get_unix_time_from_system())
	_update_timer()
	Storage.save_to_cache()
	
	booster_update.emit()

func burn_collection():
	collection = []
	dust = 0
	Storage.clear_cache()
	Storage.save_to_cache()
	_update_timer()
	
	collection_update.emit()
	dust_update.emit()
	booster_update.emit()


# helpers


func _compare_dates(date1, date2) -> bool:
	return date1["year"] < date2["year"] || date1["month"] < date2["month"] || date1["day"] < date2["day"]
