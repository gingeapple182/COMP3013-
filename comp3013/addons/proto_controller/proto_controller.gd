# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "ui_left"
## Name of Input Action to move Right.
@export var input_right : String = "ui_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "ui_up"
## Name of Input Action to move Backward.
@export var input_back : String = "ui_down"
## Name of Input Action to Jump.
@export var input_jump : String = "ui_accept"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"
## Name of Input Action to open and close the mail bag.
@export var input_mail_bag : String = "OpenMailBag"
## Name of Input Actio to open and close the skill tree
@export var input_skill_tree : String = "OpenSkillTree"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false
var item_equipped: bool = false
var item_sway_amount: float = 0.1

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider
@onready var inventory_ui: Control = $"Inventory Controller/CanvasLayer/Inventory UI"
@onready var submit_ui: SubmitMailScreen = $SubmitScreen/CanvasLayer/SubmitUI
@onready var envelope_hand: Marker3D = %envelope_hand
@onready var equipped_hand: Marker3D = %equipped_hand
@onready var skill_tree_ui: CanvasLayer = $SkillTree/CanvasLayer
@onready var interact_text: Label = %InteractText

func _ready() -> void:
	add_to_group("player")
	inventory_ui.visible = false
	submit_ui.visible = false
	submit_ui.inventory_requested.connect(_on_submit_inventory_requested)
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed(input_mail_bag):
		toggle_inventory()
	
	if event.is_action_pressed(input_skill_tree):
		print("tab")
		toggle_skill_tree()
	
	#
	#Only put movement controls past here otherwise ui keyboard inputs will not be reached
	#
	
	#if ui is open then dont let player control camera
	if GameManager.uiOpen:
		return
		
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()


func _physics_process(delta: float) -> void:
	
	#if ui is open dont let player move their character
	if GameManager.uiOpen:
		return
	
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = base_speed

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
		item_swaying(input_dir, delta)
	else:
		velocity.x = 0
		velocity.y = 0
		item_swaying(Vector2.ZERO, delta)
	
	# Use velocity to actually move
	move_and_slide()


## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func open_submit(npc: NPC) -> void:
	if inventory_ui.visible:
		inventory_ui.visible = false
	if submit_ui.visible:
		return
	
	GameManager.uiOpen = true
	release_mouse()
	submit_ui.open_screen(npc, inventory_ui.inventory_slots)

func toggle_inventory():
	if (envelope_hand.get_child_count(false) == 0 and is_mail_bag_open() == false):
		inventory_ui.visible = true
		submit_ui.visible = false
		GameManager.uiOpen = true
		release_mouse()
	else:
		close_mail_bag()

func toggle_submit():
	submit_ui.visible = !submit_ui.visible
	
	if submit_ui.visible:
		inventory_ui.visible = false
		GameManager.uiOpen = true
		release_mouse()
	else:
		GameManager.uiOpen = false
		capture_mouse()

## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false
	if not InputMap.has_action(input_mail_bag):
		push_error("Mail bag disabled. No InputAction found for input_mail_bag: " + input_mail_bag)
		

## -- helpers

func is_mail_bag_open() -> bool:
	return inventory_ui.visible

func is_submit_open() -> bool:
	return submit_ui.visible

func close_mail_bag():
	if not inventory_ui.visible:
		return
	inventory_ui.visible = false
	GameManager.uiOpen = false
	capture_mouse()

func close_submit():
	if not submit_ui.visible:
		return
	submit_ui.visible = false
	GameManager.uiOpen = false	
	capture_mouse()

func _on_submit_inventory_requested() -> void:
	inventory_ui.send_inventory_to_submit_screen(submit_ui)

func item_swaying(input_direction: Vector2, delta: float) -> void:
	if envelope_hand:
		envelope_hand.rotation.x = lerp(envelope_hand.rotation.x, -input_direction.y * item_sway_amount, 10 * delta)
		envelope_hand.rotation.z = lerp(envelope_hand.rotation.z, -input_direction.x * item_sway_amount, 10 * delta)
	if equipped_hand:
		equipped_hand.rotation.x = lerp(equipped_hand.rotation.x, -input_direction.y * item_sway_amount, 10 * delta)
		equipped_hand.rotation.z = lerp(equipped_hand.rotation.z, -input_direction.x * item_sway_amount, 10 * delta)
	
		
func toggle_skill_tree() -> void:
	if skill_tree_ui.visible:
		print("close")
		close_skill_tree()
		GameManager.uiOpen = false
	else:
		open_skill_tree()
		print("open")

		GameManager.uiOpen = true

	
func close_skill_tree() -> void:
	GameManager.uiOpen = false
	skill_tree_ui.hide()
	capture_mouse()
	
func open_skill_tree() -> void:
	GameManager.uiOpen = true
	skill_tree_ui.show()
	release_mouse()

func skill_tree_is_open() -> bool:
	return skill_tree_ui.visible
