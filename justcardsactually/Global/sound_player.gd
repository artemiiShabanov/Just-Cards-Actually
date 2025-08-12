extends Node

enum SOUND {
	SHUFFLE,
	BAP,
	CARD_SLIDE,
	BOOSTER_OPEN,
	DUST
}

var sounds = {
	SOUND.SHUFFLE: preload("res://resources/Sound/Shuffle.mp3"),
	SOUND.BAP: preload("res://resources/Sound/Tap.mp3"),
	SOUND.CARD_SLIDE: preload("res://resources/Sound/Slide.mp3"),
	SOUND.BOOSTER_OPEN: preload("res://resources/Sound/Boo.mp3"),
	SOUND.DUST: preload("res://resources/Sound/Dust.mp3"),
}

var audio_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

func play_sound(sound: SOUND):
	audio_player.stream = sounds[sound]
	audio_player.volume_db = 20
	audio_player.play()
