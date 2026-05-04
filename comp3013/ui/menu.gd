extends Control

@onready var proto_controller: CharacterBody3D = $ProtoController
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/oliver_test.tscn")

func _on_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/michael_test.tscn")

func _on_button_4_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/joemama.tscn")


func _on_button_5_pressed() -> void:
	get_tree().quit()

func _on_button_8_pressed() -> void:
	canvas_layer.show()
	pass # Replace with function body.
