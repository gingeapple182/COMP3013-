extends ActionData
class_name DeliveryAction

@export var item_address: String
@export var item_recipient: String

func _init() -> void:
	action_type = ActionType.DELIVERABLE
