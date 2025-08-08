extends Node

var cache: Dictionary = {}

const SAVE_PATH: String = "user://cache.save"

func save_to_cache():
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	file.store_var(cache)
	file.close()
	print("Cache saved successfully.")

func load_from_cache():
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		cache = file.get_var()
	else:
		push_warning("Couldn't load highscore file: ", error_string(FileAccess.get_open_error()))
		return -1

func set_value(key: String, value):
	cache[key] = value

func get_value(key: String, default_value = null):
	return cache.get(key, default_value)

func clear_cache():
	cache.clear()
	print("Cache cleared.")
