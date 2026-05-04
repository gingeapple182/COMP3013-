extends Control

@onready var central_hub_house: Node3D = $"../CentralHubHouse"
@onready var canvas_layer: CanvasLayer = $"../../CanvasLayer"
@onready var confirm: CanvasLayer = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_yes_pressed() -> void:
	canvas_layer.show()
	GameManager.uiOpen = true
	confirm.hide()
	pass # Replace with function body.


func _on_no_pressed() -> void:
	confirm.hide()
	GameManager.uiOpen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.
