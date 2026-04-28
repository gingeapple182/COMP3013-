extends TextureButton
@onready var label: Label = $"../Label"
@onready var pinboard_item: Control = $"../.."
@onready var npcs: Node = get_tree().current_scene.get_child(0)

enum NPCRole {
	BYSTANDER,
	RECIPIENT
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	npcs.get_node(label.text).npc_role = NPCRole.RECIPIENT #text on label needs to be changed
	pinboard_item.queue_free()
	pass # Replace with function body.
