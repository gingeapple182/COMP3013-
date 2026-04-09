extends InteractionComponent
class_name NPCInteraction

@onready var npc_character: NPC = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_item(mail_data: MailData) -> bool:
	if (mail_data.action_data.item_address == npc_character.npc_address or mail_data.action_data.item_recipient == npc_character.npc_name):
		_npc_interaction()
		return true
	else:
		return false
