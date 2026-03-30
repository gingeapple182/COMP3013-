extends Node3D

@export var input_openMailBag: String = "OpenMailBag"

@onready var menu: Control = $Menu
@onready var inventoryUI: Control = $"Inventory Controller/CanvasLayer/Inventory UI"

var is_paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventoryUI.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("pause"):
		if (Input.MOUSE_MODE_CAPTURED):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif (Input.MOUSE_MODE_VISIBLE):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		toggle_pause()
		
	if event.is_action_pressed("OpenMailBag"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		toggle_inventory()


func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	menu.visible = is_paused
	
func toggle_inventory():
	inventoryUI.visible = !inventoryUI.visible
