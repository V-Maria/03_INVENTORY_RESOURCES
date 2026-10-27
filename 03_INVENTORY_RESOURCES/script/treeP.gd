extends Node2D

@export var item_resources: ItemData

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		if body.equipped_tool:
			if body.equipped_tool.name == 'axe':
				var success = Global.add_item(item_resources)
				
				if success == true:
					queue_free()
