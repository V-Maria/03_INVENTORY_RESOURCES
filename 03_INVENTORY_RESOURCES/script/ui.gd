extends CanvasLayer

@export_enum("mushrooms", "acorns") var item_type: String = "mushrooms"

@export var mushroom_texture: Texture2D
@export var acorn_texture: Texture2D

@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon: TextureRect = $MarginContainer/HBoxContainer/TextureRect

func _ready() -> void:
	Global.item_collected.connect(_on_item_collected)
	_apply_icon()
	_update_label()

func _apply_icon() -> void:
	if item_type == "mushrooms":
		icon.texture = mushroom_texture
	elif item_type == "acorns":
		icon.texture = acorn_texture

func _update_label() -> void:
	if item_type == "mushrooms":
		label.text = str(Global.mushrooms_collected)
	elif item_type == "acorns":
		label.text = str(Global.acorns_collected)

func _on_item_collected(collected_type: String) -> void:
	if collected_type != item_type:
		return
	if item_type == "mushrooms":
		Global.mushrooms_collected += 1
	elif item_type == "acorns":
		Global.acorns_collected += 1
	_update_label()
