extends Node3D

@onready var hud = $CanvasLayer/HUD
@onready var booster_scene: Booster = $Booster
@onready var collection_scene: Collection = $Collection

func _ready() -> void:
	collection_scene._hide()

func _on_hud_state_changed(state: int) -> void:
	if state == HUD.STATE.BOOSTER:
		booster_scene._show()
		collection_scene._hide()
	elif state == HUD.STATE.COLLECTION:
		booster_scene._hide()
		collection_scene._show()
