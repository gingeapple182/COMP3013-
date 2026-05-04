extends Node3D

@onready var menu: Control = $Menu
@onready var proto_controller: CharacterBody3D = $ProtoController
@onready var are_you_sure_: Control = $"Are you sure?"

var is_paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameManager.uiOpen = true
		open_AreYouSure()
		#toggle_pause()

func open_AreYouSure():
	GameManager.uiOpen = true
	are_you_sure_.show()

func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	menu.visible = is_paused
