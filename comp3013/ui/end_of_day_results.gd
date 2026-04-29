extends Control
@onready var canvas_layer: CanvasLayer = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_day_pressed() -> void:
	GameManager.newDay()
	canvas_layer.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.uiOpen = false
	for npc in get_tree().current_scene.get_child(0).get_children():
		npc.npc_role = NPC.NPCRole.BYSTANDER
	pass # Replace with function body.
