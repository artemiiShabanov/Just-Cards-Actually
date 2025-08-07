extends Node3D

@onready var hud = $CanvasLayer/HUD
@onready var booster_scene = $Booster
@onready var collection_scene = $Collection

func _ready() -> void:
	collection_scene.visible = false

func _on_hud_state_changed(state: int) -> void:
	if state == HUD.STATE.BOOSTER:
		booster_scene.visible = true
		collection_scene.visible = false
	elif state == HUD.STATE.COLLECTION:
		booster_scene.visible = false
		collection_scene.visible = true
