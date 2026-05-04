extends Control
@onready var menu: Control = $"../Menu"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_canvas_layers(node):
	for child in node.get_children():
		if child is CanvasLayer:
			child.hide()
		hide_canvas_layers(child)

func _on_button_5_pressed() -> void:
	get_tree().paused = true
	self.hide()
	menu.visible = true
	GameManager.uiOpen = false
	hide_canvas_layers(get_tree().current_scene)
	pass # Replace with function body.


func _on_button_pressed() -> void:
	GameManager.uiOpen = false
	self.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	print("asdsadasdasdasd")
	pass # Replace with function body.
