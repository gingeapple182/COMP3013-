class_name AbstractInteraction
extends Node

@export var nodes_to_affect: Array[Node]

var object_reference: Node3D
var can_interact: bool = true
var is_interacting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	object_reference = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_item(mail_data: MailData) -> bool:
	return false
