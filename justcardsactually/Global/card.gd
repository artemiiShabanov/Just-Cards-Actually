class_name Card

var suit: SUIT
var rank: RANK
var level: LEVEL:
	get:
		return level_for_rank(rank)

var description: String:
	get:
		return "%s%s" % [SUIT_TO_STR[suit], RANK_TO_STR[rank]]
		
func to_dict() -> Dictionary:
	return {
		"suit": suit,
		"rank": rank
	}

static func from_dict(data: Dictionary) -> Card:
	return Card.create(data["suit"], data["rank"])

func eq(other: Card) -> bool:
	return suit == other.suit && rank == other.rank
	
static func create(_suit: SUIT, _rank: RANK) -> Card:
	var instance = Card.new()
	instance.suit = _suit
	instance.rank = _rank
	return instance

enum SUIT {LIGHTNING, WATER, FIRE, EARTH}
enum RANK {ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE, JOKER, RJOKER, ERROR}
enum LEVEL {COMMON, RARE, EPIC, LEGENDARY}

const SUIT_TO_STR = {
	SUIT.LIGHTNING: "L",
	SUIT.WATER: "W",
	SUIT.FIRE: "F",
	SUIT.EARTH: "E"
}

const RANK_TO_STR = {
	RANK.ONE: "1",
	RANK.TWO: "2",
	RANK.THREE: "3",
	RANK.FOUR: "4",
	RANK.FIVE: "5",
	RANK.SIX: "6",
	RANK.SEVEN: "7",
	RANK.EIGHT: "8",
	RANK.NINE: "9",
	RANK.TEN: "10",
	RANK.JACK: "J",
	RANK.QUEEN: "Q",
	RANK.KING: "K",
	RANK.ACE: "A",
	RANK.JOKER: "JK",
	RANK.RJOKER: "KJ",
	RANK.ERROR: "E"
}

static func level_for_rank(_rank: RANK) -> LEVEL:
	match _rank:
		RANK.ONE, RANK.TWO, RANK.THREE, RANK.FOUR, RANK.FIVE, RANK.SIX, RANK.SEVEN, RANK.EIGHT, RANK.NINE, RANK.TEN:
			return LEVEL.COMMON
		RANK.JACK, RANK.QUEEN, RANK.KING, RANK.ACE:
			return LEVEL.RARE
		RANK.JOKER, RANK.RJOKER:
			return LEVEL.EPIC
		RANK.ERROR:
			return LEVEL.LEGENDARY
	return LEVEL.COMMON

static func ranks_for_level(_level: LEVEL) -> Array:
	match _level:
		LEVEL.COMMON:
			return [RANK.ONE, RANK.TWO, RANK.THREE, RANK.FOUR, RANK.FIVE, RANK.SIX, RANK.SEVEN, RANK.EIGHT, RANK.NINE, RANK.TEN]
		LEVEL.RARE:
			return [RANK.JACK, RANK.QUEEN, RANK.KING, RANK.ACE]
		LEVEL.EPIC:
			return [RANK.JOKER, RANK.RJOKER]
		LEVEL.LEGENDARY:
			return [RANK.ERROR]
	return []
