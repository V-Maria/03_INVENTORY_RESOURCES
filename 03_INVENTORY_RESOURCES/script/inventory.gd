extends CanvasLayer

@export var grid: GridContainer

func _ready():
	Global.inventory_updated.connect(refresh_ui)
	refresh_ui()

func refresh_ui():
	# Очистка старых слотов
	for child in grid.get_children(): child.queue_free()
	
	var index = 0 
	
	for item in Global.inventory:
		var slot = Button.new()
		slot.icon = item.icon
		slot.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.custom_minimum_size = Vector2(15, 15)
		

		slot.pressed.connect(on_slot_pressed.bind(index))
		
		grid.add_child(slot)
		
		if item.amount > 1:
			var count_label = Label.new()
			count_label.text = str(item.amount)
			count_label.add_theme_font_size_override("font_size", 10)
			count_label.add_theme_color_override("font_color", Color.WHITE) # Белый текст
			count_label.add_theme_font_override("font", load("res://assets/ComicoroRu_0.ttf"))
			count_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
			count_label.position = Vector2(-2, -2) 
			
			count_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			count_label.grow_vertical = Control.GROW_DIRECTION_BEGIN
			
			slot.add_child(count_label)
		
		index += 1 
func on_slot_pressed(slot_index: int):
	Global.active_slot_index = slot_index
	update_selection_visual()
	

	var player = get_tree().current_scene.get_node_or_null("Player")
	if player:
		player.update_hand_visual()

func update_selection_visual():
	var slots = grid.get_children()
	for i in range(slots.size()):
		if i == Global.active_slot_index:
			slots[i].grab_focus()
		else:
			slots[i].release_focus()
