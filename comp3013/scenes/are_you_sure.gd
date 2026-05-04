extends Control
@onready var menu: Control = $"../Menu"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_5_pressed() -> void:
	get_tree().paused = true
	visible = false
	menu.visible = true

	pass # Replace with function body.


func _on_button_pressed() -> void:
	GameManager.uiOpen = false
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass # Replace with function body.
