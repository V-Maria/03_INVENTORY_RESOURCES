extends Node2D

@export var item_resources: ItemData
@export var sprite: Sprite2D

func _ready() -> void:
	if item_resources and sprite:
		sprite.texture = item_resources.icon

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":

		var already_has = false
		for item in Global.inventory:
			if item.name == item_resources.name:
				already_has = true
				break
		

		if not already_has and Global.inventory.size() >= Global.max_inventory_size:

			$Area2D.set_deferred("monitoring", false) 

			return 
			
		if Global.add_item(item_resources):
			queue_free()
