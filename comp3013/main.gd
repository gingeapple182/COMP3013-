extends Node3D

@onready var menu: Control = $Menu
@onready var proto_controller: CharacterBody3D = $ProtoController

var is_paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_canvas_layers(node):
	for child in node.get_children():
		if child is CanvasLayer:
			child.visible = false
		hide_canvas_layers(child)

func _input(event):
	if event.is_action_pressed("pause"):
		hide_canvas_layers(get_tree().current_scene)
		GameManager.uiOpen = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		toggle_pause()


func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	menu.visible = is_paused
