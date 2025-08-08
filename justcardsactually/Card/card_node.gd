extends Node3D

class_name CardNode

signal tapped(node: CardNode)

@export var suit: Card.SUIT
@export var rank: Card.RANK
@onready var mesh = $CardMesh

func _ready() -> void:
	var card = Card.create(suit, rank)
	mesh.set_surface_override_material(0, materials[card.description])


func _on_rotator_tap_detected() -> void:
	tapped.emit(self)


const materials = {
	"L1": preload("res://Card/materials/L1.tres"),
	"L2": preload("res://Card/materials/L2.tres"),
	"L3": preload("res://Card/materials/L3.tres"),
	"L4": preload("res://Card/materials/L4.tres"),
	"L5": preload("res://Card/materials/L5.tres"),
	"L6": preload("res://Card/materials/L6.tres"),
	"L7": preload("res://Card/materials/L7.tres"),
	"L8": preload("res://Card/materials/L8.tres"),
	"L9": preload("res://Card/materials/L9.tres"),
	"L10": preload("res://Card/materials/L10.tres"),
	"LJ": preload("res://Card/materials/LJ.tres"),
	"LQ": preload("res://Card/materials/LQ.tres"),
	"LK": preload("res://Card/materials/LK.tres"),
	"LA": preload("res://Card/materials/LA.tres"),
	"LJK": preload("res://Card/materials/LJK.tres"),
	"LKJ": preload("res://Card/materials/LKJ.tres"),
	"LE": preload("res://Card/materials/LE.tres"),
	"F1": preload("res://Card/materials/F1.tres"),
	"F2": preload("res://Card/materials/F2.tres"),
	"F3": preload("res://Card/materials/F3.tres"),
	"F4": preload("res://Card/materials/F4.tres"),
	"F5": preload("res://Card/materials/F5.tres"),
	"F6": preload("res://Card/materials/F6.tres"),
	"F7": preload("res://Card/materials/F7.tres"),
	"F8": preload("res://Card/materials/F8.tres"),
	"F9": preload("res://Card/materials/F9.tres"),
	"F10": preload("res://Card/materials/F10.tres"),
	"FJ": preload("res://Card/materials/FJ.tres"),
	"FQ": preload("res://Card/materials/FQ.tres"),
	"FK": preload("res://Card/materials/FK.tres"),
	"FA": preload("res://Card/materials/FA.tres"),
	"FJK": preload("res://Card/materials/FJK.tres"),
	"FKJ": preload("res://Card/materials/FKJ.tres"),
	"FE": preload("res://Card/materials/FE.tres"),
	"W1": preload("res://Card/materials/W1.tres"),
	"W2": preload("res://Card/materials/W2.tres"),
	"W3": preload("res://Card/materials/W3.tres"),
	"W4": preload("res://Card/materials/W4.tres"),
	"W5": preload("res://Card/materials/W5.tres"),
	"W6": preload("res://Card/materials/W6.tres"),
	"W7": preload("res://Card/materials/W7.tres"),
	"W8": preload("res://Card/materials/W8.tres"),
	"W9": preload("res://Card/materials/W9.tres"),
	"W10": preload("res://Card/materials/W10.tres"),
	"WJ": preload("res://Card/materials/WJ.tres"),
	"WQ": preload("res://Card/materials/WQ.tres"),
	"WK": preload("res://Card/materials/WK.tres"),
	"WA": preload("res://Card/materials/WA.tres"),
	"WJK": preload("res://Card/materials/WJK.tres"),
	"WKJ": preload("res://Card/materials/WKJ.tres"),
	"WE": preload("res://Card/materials/WE.tres"),
	"E1": preload("res://Card/materials/E1.tres"),
	"E2": preload("res://Card/materials/E2.tres"),
	"E3": preload("res://Card/materials/E3.tres"),
	"E4": preload("res://Card/materials/E4.tres"),
	"E5": preload("res://Card/materials/E5.tres"),
	"E6": preload("res://Card/materials/E6.tres"),
	"E7": preload("res://Card/materials/E7.tres"),
	"E8": preload("res://Card/materials/E8.tres"),
	"E9": preload("res://Card/materials/E9.tres"),
	"E10": preload("res://Card/materials/E10.tres"),
	"EJ": preload("res://Card/materials/EJ.tres"),
	"EQ": preload("res://Card/materials/EQ.tres"),
	"EK": preload("res://Card/materials/EK.tres"),
	"EA": preload("res://Card/materials/EA.tres"),
	"EJK": preload("res://Card/materials/EJK.tres"),
	"EKJ": preload("res://Card/materials/EKJ.tres"),
	"EE": preload("res://Card/materials/EE.tres")
}
