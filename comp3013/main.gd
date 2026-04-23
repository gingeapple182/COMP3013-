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


func _input(event):
	if event.is_action_pressed("pause"):
		if proto_controller.is_mail_bag_open():
			proto_controller.close_mail_bag()
		if proto_controller.is_submit_open():
			proto_controller.close_submit()
		if proto_controller.skill_tree_is_open():
			proto_controller.close_skill_tree()
		if proto_controller.interact_text.visible:
			proto_controller.interact_text.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		toggle_pause()


func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	menu.visible = is_paused
