extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var name_label: Label = $NameLabel
@onready var cam: Camera2D = $Camera2D

# Стартовая позиция в level2
const SPAWN := Vector2(104, 64)

const MAP_RECT := Rect2(0, 0, 224, 127)

var speed: int = 40
var is_sitting: bool = false

func _ready() -> void:
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
	elif input.x < 0:
		anim.flip_h = false
	if input != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("idle")
	move_and_slide()
	
@export var hand: Sprite2D

func _unhandled_input(event):
	if event.is_action_pressed('use_tool'):
		if Global.inventory.size() > 0:
			var item = Global.inventory[0]
			if item.is_tool:
				hand.texture = item.icon
