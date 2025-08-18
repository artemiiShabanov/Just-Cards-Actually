extends Control
class_name HUD

enum STATE { BOOSTER, COLLECTION }
signal state_changed(state: STATE)

var state: STATE = STATE.BOOSTER

@onready var state_button = $MarginContainer2/StateButton
@onready var dust_text = $MarginContainer/DustContainer/DustText
@onready var debug_view = $Debug

func _ready() -> void:
	Player.dust_update.connect(_on_dust_updated)
	Player.collection_update.connect(_on_collection_updated)
	_on_dust_updated()
	_on_collection_updated()
	return

func _on_dust_updated():
	dust_text.text = "%d" % Player.dust
	
func _on_collection_updated():
	state_button.text = "%d/%d" % [Player.collection.size(), Player.COLLECTION_FULL_SIZE]

func _on_state_button_toggled(toggled_on: bool) -> void:
	SoundPlayer.play_sound(SoundPlayer.SOUND.BAP)
	state = STATE.COLLECTION if toggled_on else STATE.BOOSTER
	state_changed.emit(state)

func _on_debug_button_pressed() -> void:
	debug_view.visible = true
