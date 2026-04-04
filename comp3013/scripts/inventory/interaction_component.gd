extends AbstractInteraction
class_name InteractionComponent

enum InteractionType { DEFAULT, MAIL, NPC }

@export var interaction_type: InteractionType = InteractionType.DEFAULT
@export var mail_data: MailData

var player_hand: Marker3D
var has_output := false

signal item_collected(item: Node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	var scene_path: String = get_parent().scene_file_path
	mail_data.item_model_prefab = load(scene_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func preInteract(hand: Marker3D) -> void:
	is_interacting = true
	player_hand = hand
	
func interact() -> void:
	if(!can_interact):
		return
	
	match interaction_type:
		InteractionType.DEFAULT:
			_default_interact()
		InteractionType.MAIL:
			_collect_mail()
		InteractionType.NPC:
			_npc_interaction()

func postInteract() -> void:
	is_interacting = false
	has_output = false

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
	emit_signal("item_collected", get_parent())

func _npc_interaction() -> void:
	if has_output:
		return
	
	has_output = true
	
	var npc := get_parent() as NPC
	
	print("NPC interaction triggered")
	print("NPC role: ", NPC.NPCRole.keys()[npc.npc_role])
	
	if npc.npc_role != NPC.NPCRole.RECIPIENT:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("No player found in group 'player'.")
		return
	
	player.open_submit(npc)
