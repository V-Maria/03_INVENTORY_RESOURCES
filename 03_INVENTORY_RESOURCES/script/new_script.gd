extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var name_label: Label = $NameLabel
@onready var cam: Camera2D = $Camera2D
@export var item_resources: ItemData
@export var item_world_scene: PackedScene 
var is_tool_drawn: bool = false
# Пишем, что при нажаии ЛКМ - присваиваем equipped_tool, текущий инструмент
var equipped_tool: ItemData


# Стартовая позиция в forest 
const SPAWN := Vector2(104, 64)

const MAP_RECT := Rect2(0, 0, 224, 127)

var speed: int = 40
var is_sitting: bool = false

func _ready() -> void:
	Global.add_item(item_resources)
	
	global_position = SPAWN
	if Global.player_name != "":
		name_label.text = Global.player_name
	else:
		name_label.text = "Игрок"
		
	cam.zoom = Vector2(2, 2)
	cam.limit_left = int(MAP_RECT.position.x)
	cam.limit_top = int(MAP_RECT.position.y)
	cam.limit_right = int(MAP_RECT.position.x + MAP_RECT.size.x)
	cam.limit_bottom = int(MAP_RECT.position.y + MAP_RECT.size.y)

func _physics_process(_delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	velocity = input.normalized() * speed
	if input.x > 0:
		anim.flip_h = true
		if hand: hand.flip_h = true
	elif input.x < 0:
		anim.flip_h = false
		if hand: hand.flip_h = false
	if input != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("idle")
	move_and_slide()

@export var hand: Sprite2D

func _unhandled_input(event):
	if event.is_action_pressed('use_tool'):
		use_equipped_tool()
	if event.is_action_pressed('next_item'):
		change_selection(1)
	if event.is_action_pressed('prev_item'):
		change_selection(-1)     
		# Обработка нажатия клавиши Q
	if event.is_action_pressed('drop_item'):
		drop_item()  

func change_selection(direction: int):
	if Global.inventory.size() == 0: return
	
	# Алгоритм зацикливания индекса
	Global.active_slot_index = (Global.active_slot_index + direction) % Global.inventory.size()
	if Global.active_slot_index < 0: Global.active_slot_index = Global.inventory.size() - 1
	
	update_hand_visual()
	
func update_hand_visual():
	# Проверяем, есть ли вообще предметы в инвентаре и не вышел ли индекс за границы
	if Global.inventory.size() > 0 and Global.active_slot_index >= 0:
		# Берем предмет из активного слота
		var item = Global.inventory[Global.active_slot_index]
		
		# Проверяем, что предмет существует 
		if item:
			hand.texture = item.icon
			# Если это инструмент, экипируем его
			equipped_tool = item if item.is_tool else null
		else:
			# Если в слоте  null
			hand.texture = null
			equipped_tool = null
	else:
		# Если инвентарь пуст очищаем руку и сбрасываем инструмент
		hand.texture = null
		equipped_tool = null
		


func drop_item():
	if Global.inventory.size() > 0:
		var item_to_drop = Global.inventory[Global.active_slot_index]
		
		# Если в стаке больше 1 штуки
		if item_to_drop.amount > 1:
			item_to_drop.amount -= 1 # Уменьшаем стак на 1
			
			# Создаем копию предмета, чтобы выбросить только 1 штуку
			var single_item = item_to_drop.duplicate()
			single_item.amount = 1 
			
			spawn_dropped_item(single_item)
		else:
			# Если предмет был один, удаляем слот
			Global.inventory.remove_at(Global.active_slot_index)
			spawn_dropped_item(item_to_drop)
			
		# Корректируем слот и обновляем UI
		Global.active_slot_index = clamp(Global.active_slot_index, 0, Global.inventory.size() - 1)
		Global.inventory_updated.emit()
		update_hand_visual()
		

func spawn_dropped_item(item_to_drop: ItemData):
	var new_item = item_world_scene.instantiate()
	
	#  задаем позицию и данные
	var drop_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	new_item.position = self.position + drop_direction * randf_range(20, 20)
	new_item.item_resources = item_to_drop
	
	# добавляем в мир
	get_tree().current_scene.add_child(new_item)
	
func use_equipped_tool():
	# Если в руках есть инструмент
	if equipped_tool != null:
		is_tool_drawn = !is_tool_drawn # Переключаем состояние
		
		if is_tool_drawn:
			# Достаем топор
			hand.visible = true
			hand.texture = equipped_tool.icon
		else:
			# Убираем топор
			hand.visible = false
