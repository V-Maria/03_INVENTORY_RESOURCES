extends Area2D

@export var item_id: String = "acorns"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Acorn touched by: ", body.name)
	if body.name == "Player" or body.name == "Player2":
		Global.item_collected.emit(item_id)
		get_parent().queue_free()
