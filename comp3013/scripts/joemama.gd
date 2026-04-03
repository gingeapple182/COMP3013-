extends Node3D

@onready var menu: Control = $Menu
@onready var skill_tree: Control = $SkillTree
@onready var button: Button = $CanvasLayer/Button
@onready var proto_controller: CharacterBody3D = $ProtoController

var is_paused := false

func _input(event):
	if event.is_action_pressed("pause"):
		if proto_controller.is_mail_bag_open():
			proto_controller.close_mail_bag()
			return
		skill_tree.visible = false
		button.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		toggle_pause()

func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	menu.visible = is_paused


func _on_button_pressed() -> void:
	skill_tree.visible = !skill_tree.visible
	pass # Replace with function body.
