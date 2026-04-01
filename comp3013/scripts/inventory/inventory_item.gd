extends Control
class_name InventoryItem

@onready var item_icon: TextureRect = $TextureRect

var slot_filled: bool = false
var slot_data: MailData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_slot(mail_data: MailData) -> void:
	slot_data = mail_data
	if (slot_data != null):
		slot_filled = true
		item_icon.texture = mail_data.item_icon
	else:
		slot_filled = false
		item_icon.texture = null
