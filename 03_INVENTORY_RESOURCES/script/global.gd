extends Node 
const MAX_STACK_SIZE: int = 10
@export var max_inventory_size: int = 4
# Сигнал передает имя предмета 
signal item_collected(item_name: String)
var player_name="Игрок"

var spawn_position: Vector2 = Vector2.ZERO   

var mushrooms_collected: int = 0
var acorns_collected: int = 0

signal inventory_updated
var inventory: Array[ItemData] = []

var active_slot_index: int = 0


func add_item(new_item: ItemData) -> bool:
	var found_item = null

	for item in inventory:
		if item.name == new_item.name:
			if item.amount < MAX_STACK_SIZE:
				found_item = item
				break

	if found_item != null:
		var space_left = MAX_STACK_SIZE - found_item.amount
		
		if space_left >= new_item.amount:
			found_item.amount += new_item.amount
		else:
			found_item.amount += space_left 
			var remaining = new_item.amount - space_left
			var new_stack = new_item.duplicate()
			new_stack.amount = remaining
			inventory.append(new_stack)
			
		inventory_updated.emit()
		return true
		
	
	if inventory.size() >= max_inventory_size:
		return false 
		
	var item_copy = new_item.duplicate()
	item_copy.amount = new_item.amount 
	inventory.append(item_copy)
	inventory_updated.emit()
	return true
