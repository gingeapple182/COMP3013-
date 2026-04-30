extends TextureButton
@onready var label: Label = $"../Label"
@onready var pinboard_item: Control = $"../.."
@onready var npcs: Node = get_tree().current_scene.get_child(0)
var mail_scene = preload("res://scenes/props/mail_piece.tscn")

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
	var mail = mail_scene.instantiate()
	for npc in get_tree().current_scene.get_child(0).get_children():
		if npc.npc_name == label.text:
			var delivery_action := DeliveryAction.new()
			delivery_action.item_address = [npc.npc_address]
			delivery_action.item_recipient = label.text
			mail.get_child(2).mail_data.action_data = delivery_action

	mail.position = Vector3(92.152,0.5,143.215)
	get_tree().current_scene.add_child(mail)
	pass # Replace with function body.
