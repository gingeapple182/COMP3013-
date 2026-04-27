class_name NPC
extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var name_label: Label3D = $CollisionShape3D/Label3D
@onready var sprite_3d: Sprite3D = $CollisionShape3D/Sprite3D

const EMOTE_FACE_ANGRY = preload("uid://e5ohwhqxe1sf")
const EMOTE_FACE_HAPPY = preload("uid://cfypbp2o7jefs")
const EMOTE_FACE_SAD = preload("uid://d03gpeefblpom")

enum NPCRole {
	BYSTANDER,
	RECIPIENT
}

enum NPCState {
	IDLE,
	WANDER,
	DESTINATION,
	RETURN,
	KILL
}

@export var npc_name: String
@export var npc_address: String

@export_group("NPC Role")
@export var npc_role: NPCRole = NPCRole.BYSTANDER
@export_group("NPC State")
@export var base_state: NPCState = NPCState.IDLE
@export var starting_state: NPCState = NPCState.IDLE

var current_state: NPCState = NPCState.IDLE

@export_group("Movement")
@export var move_speed: float = 2.5
@export var rotation_speed: float = 8.0
@export var stop_distance: float = 0.2

@export_group("Idle Settings")
@export var idle_wait_min: float = 1.5
@export var idle_wait_max: float = 3.5

@export_group("Markers")
@export var wander_markers: Array[NodePath] = []
@export var home_marker: NodePath
@export var destination_marker: NodePath

@export_group("Targets")
@export var player_path: NodePath

var player: Node3D = null
var idle_timer: float = 0.0
var current_idle_wait: float = 0.0
var current_wander_index: int = 0
var safe_velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	navigation_agent.path_desired_distance = stop_distance
	navigation_agent.target_desired_distance = stop_distance
	if not navigation_agent.velocity_computed.is_connected(_on_velocity_computed):
		navigation_agent.velocity_computed.connect(_on_velocity_computed)
	
		player = get_node_or_null(player_path) as Node3D
	if player == null:
		npc_log("Player path is not assigned or invalid.")
	
	name_label.text = npc_name 
	current_idle_wait = randf_range(idle_wait_min, idle_wait_max)
	current_state = starting_state
	npc_log("STARTING STATE: %s | BASE STATE: %s" % [NPCState.keys()[current_state], NPCState.keys()[base_state]])
	enter_current_state()


func _physics_process(delta: float) -> void:
	match current_state:
		NPCState.IDLE:
			handle_idle_state(delta)
		NPCState.WANDER:
			handle_wander_state()
		NPCState.DESTINATION:
			handle_destination_state()
		NPCState.RETURN:
			handle_return_state()
		NPCState.KILL:
			handle_kill_state()
	
	velocity = safe_velocity
	move_and_slide()
	#apply_floor_snap()

func _on_velocity_computed(new_safe_velocity: Vector3) -> void:
	safe_velocity = new_safe_velocity

# =========================================================
# STATE CHANGES
# =========================================================

func change_state(new_state: NPCState) -> void:
	if current_state == new_state:
		return
	
	npc_log("STATE CHANGE: %s -> %s" % [NPCState.keys()[current_state], NPCState.keys()[new_state]])
	current_state = new_state
	enter_current_state()


func return_to_base_state() -> void:
	change_state(base_state)


func enter_current_state() -> void:
	match current_state:
		NPCState.IDLE:
			enter_idle_state()
		NPCState.WANDER:
			enter_wander_state()
		NPCState.DESTINATION:
			enter_destination_state()
		NPCState.RETURN:
			enter_return_state()
		NPCState.KILL:
			enter_kill_state()
	
	update_animation()


# =========================================================
# IDLE
# =========================================================

func enter_idle_state() -> void:
	velocity = Vector3.ZERO
	idle_timer = 0.0
	current_idle_wait = randf_range(idle_wait_min, idle_wait_max)


func handle_idle_state(delta: float) -> void:
	velocity = Vector3.ZERO
	if GameManager.player.Reputation <= 0:
		set_icon_state("sad")
		
	if base_state == NPCState.WANDER and wander_markers.size() > 0:
		idle_timer += delta
		if idle_timer >= current_idle_wait:
			change_state(NPCState.WANDER)


# =========================================================
# WANDER
# =========================================================

func enter_wander_state() -> void:
	if wander_markers.is_empty():
		npc_log("No wander markers assigned.")
		change_state(NPCState.IDLE)
		return
	
	var marker := get_marker_node(wander_markers[current_wander_index])
	if marker == null:
		npc_log("Wander marker at index %d is invalid." % current_wander_index)
		change_state(NPCState.IDLE)
		return
	
	navigation_agent.set_target_position(marker.global_position)


func handle_wander_state() -> void:
	if wander_markers.is_empty():
		velocity = Vector3.ZERO
		change_state(NPCState.IDLE)
		return
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		
		current_wander_index += 1
		if current_wander_index >= wander_markers.size():
			current_wander_index = 0
		
		change_state(NPCState.IDLE)
		return
	
	move_towards_next_path_point()


# =========================================================
# DESTINATION
# =========================================================

func enter_destination_state() -> void:
	var marker := get_marker_node(destination_marker)
	if marker == null:
		npc_log("Destination marker is not assigned or invalid.")
		change_state(NPCState.IDLE)
		return
	
	navigation_agent.set_target_position(marker.global_position)


func handle_destination_state() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		npc_log("Reached destination marker.")
		return_to_base_state()
		return
	
	move_towards_next_path_point()


# =========================================================
# RETURN
# =========================================================

func enter_return_state() -> void:
	var marker := get_marker_node(home_marker)
	if marker == null:
		npc_log("Home marker is not assigned or invalid.")
		change_state(NPCState.IDLE)
		return
	
	navigation_agent.set_target_position(marker.global_position)


func handle_return_state() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		npc_log("Returned home.")
		return_to_base_state()
		return
	
	move_towards_next_path_point()

func enter_kill_state() -> void:
	if player == null:
		npc_log("Cannot enter KILL state, player is missing.")
		change_state(NPCState.IDLE)
		return
	
	sprite_3d
	navigation_agent.set_target_position(player.global_position)

func handle_kill_state() -> void:
	if player == null:
		velocity = Vector3.ZERO
		npc_log("Player missing during KILL state.")
		change_state(NPCState.IDLE)
		return
	set_icon_state("angry")
	navigation_agent.set_target_position(player.global_position)
	move_towards_next_path_point()


# =========================================================
# MOVEMENT
# =========================================================

func move_towards_next_path_point() -> void:
	var next_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = next_position - global_position
	#direction.y = 0.0
	
	if direction.length() <= 0.01:
		navigation_agent.velocity = Vector3.ZERO
		safe_velocity = Vector3.ZERO
		return
	
	direction = direction.normalized()
	var desired_velocity: Vector3 = direction * move_speed
	
	navigation_agent.velocity = desired_velocity
	
	var flat_safe_velocity := safe_velocity
	flat_safe_velocity.y = 0.0
	
	if flat_safe_velocity.length() > 0.01:
		var target_angle := atan2(flat_safe_velocity.x, flat_safe_velocity.z)
		rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * get_physics_process_delta_time())


# =========================================================
# VISUALS
# =========================================================

func update_animation() -> void:
	if animation_player == null:
		return
	
	var animation_name := ""
	
	match current_state:
		NPCState.IDLE:
			animation_name = "idle/Root|Idle"
		NPCState.WANDER, NPCState.DESTINATION, NPCState.RETURN, NPCState.KILL:
			animation_name = "run/Root|Run"
	
	if animation_name != "" and animation_player.current_animation != animation_name:
		animation_player.play(animation_name)

func set_icon_state(state: String) -> void:
	match state:
		"happy":
			sprite_3d.texture = EMOTE_FACE_HAPPY
		"sad":
			sprite_3d.texture = EMOTE_FACE_SAD
		"angry":
			sprite_3d.texture = EMOTE_FACE_ANGRY

# =========================================================
# HELPERS
# =========================================================

func get_marker_node(path: NodePath) -> Marker3D:
	if path.is_empty():
		return null
	
	var node := get_node_or_null(path)
	if node is Marker3D:
		return node
	
	return null


func set_destination_marker(marker_path: NodePath) -> void:
	destination_marker = marker_path
	change_state(NPCState.DESTINATION)


func start_return() -> void:
	change_state(NPCState.RETURN)


func start_idle() -> void:
	change_state(NPCState.IDLE)


func start_wander() -> void:
	change_state(NPCState.WANDER)


func start_kill() -> void:
	change_state(NPCState.KILL)


func npc_log(message: String) -> void:
	print("NPC: ", npc_name, ": ", message)
