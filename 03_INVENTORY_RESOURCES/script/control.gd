extends Control

@onready var name_input: LineEdit = $Control/MarginContainer/NameInput
@onready var error_label: Label = $Control/MarginContainer/ErrorLabel
@onready var start_button: Button = $Control/MarginContainer/StartButton

func _ready() -> void:
	error_label.visible = false
	start_button.pressed.connect(_on_start_button_pressed)
	# Ловим изменение текста → прячем ошибку
	name_input.text_changed.connect(_on_text_changed)
	# Enter в поле = нажатие кнопки
	name_input.text_submitted.connect(_on_text_submitted)
	# Фокус на поле сразу при старте
	name_input.grab_focus()

func _on_text_changed(_new_text: String) -> void:
	# Как только пользователь начал что-то менять — прячем ошибку
	error_label.visible = false

func _on_text_submitted(_text: String) -> void:
	_on_start_button_pressed()

func _on_start_button_pressed() -> void:
	var player_name := name_input.text.strip_edges()

	if player_name.length() > 2:
		Global.player_name = player_name
		get_tree().change_scene_to_file("res://scenes/forest.tscn")
	else:
		error_label.text = "Имя должно быть \nбольше 2 символов!"
		error_label.visible = true
