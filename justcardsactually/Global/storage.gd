extends Node

var collection: Array = []
var cache: Dictionary = {}

const SAVE_PATH: String = "user://cache.save"

func save_to_cache():
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	var serialized = []
	for obj in collection:
		serialized.append(obj.to_dict())
	file.store_var(serialized)
	file.store_var(cache)
	file.close()

func load_from_cache():
	clear_cache()
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var serialized = file.get_var()
		if serialized is Array:
			for obj in serialized:
				collection.append(Card.from_dict(obj))
		var _cache = file.get_var()
		if _cache != null:
			cache = _cache
		file.close()

func set_collection(_collection: Array):
	collection = _collection

func get_collection() -> Array:
	return collection
	
func set_value(key: String, value):
	cache[key] = value

func get_value(key: String, default_value = null):
	return cache.get(key, default_value)

func clear_cache():
	collection.clear()
	cache.clear()
	print("Cache cleared.")
