extends Resource
class_name MailData

@export var item_name: String
@export var item_icon: Texture2D
@export var action_data: ActionData
var item_model_prefab: PackedScene

var deliver_action: DeliveryAction
var interactable_action: InteractAction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
