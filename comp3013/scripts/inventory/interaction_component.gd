extends Node

enum InteractionType { DEFAULT, MAIL }

@export var object_reference: Node3D
@export var interaction_type: InteractionType = InteractionType.MAIL

var can_interact: bool = true
var is_interacting: bool = false
var player_hand: Marker3D

signal item_collected(item: Node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func preInteract(hand: Marker3D) -> void:
	is_interacting = true
	match interaction_type:
		InteractionType.MAIL:
			player_hand = hand
	
func interact() -> void:
	if(!can_interact):
		return
	
	match interaction_type:
		InteractionType.MAIL:
			_default_interact()
	
func postInteract() -> void:
	is_interacting = false

func _input(event: InputEvent) -> void:
	return
	
func _default_interact() -> void:
	var object_current_position: Vector3 = object_reference.global_transform.origin
	var player_hand_position: Vector3 = player_hand.global_transform.origin
	var object_distance: Vector3 = player_hand_position - object_current_position
	
	var rigid_body_3d: RigidBody3D = object_reference as RigidBody3D
	if (rigid_body_3d):
		rigid_body_3d.set_linear_velocity((object_distance) * (5 / rigid_body_3d.mass))

func _collect_mail() -> void:
	emit_signal("item_collected")
