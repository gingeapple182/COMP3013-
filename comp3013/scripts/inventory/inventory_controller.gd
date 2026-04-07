extends Control

@onready var player_camera: Camera3D = $"../../../Head/Camera3D"
@onready var item_interaction: Node = $"../../../item_interaction"
@onready var hand: Marker3D = $"../../../Head/Camera3D/Marker3D"
@onready var context_menu: PopupMenu = PopupMenu.new()

var item_slots_count: int = 20
var inventory_slot_prefab: PackedScene = load("res://scripts/inventory/inventory_item.tscn")
@export var inventory_grid: GridContainer
var inventory_slots: Array[InventoryItem] = []
var inventory_full: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in item_slots_count:
		var item = inventory_slot_prefab.instantiate() as InventoryItem
		inventory_grid.add_child(item)
		item.slot_index = i
		item.on_item_swapped.connect(item_moving_slot)
		item.on_item_double_clicked.connect(item_double_clicked)
		item.on_item_right_clicked.connect(item_right_clicked)
		inventory_slots.append(item)
	add_child(context_menu)
	context_menu.connect("id_pressed", Callable(self, "_on_context_menu"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func has_free_slot() -> bool:
	for slot in inventory_slots:
		if (slot.slot_data == null):
			return true
	return false

func pickup_item(mail_data: MailData) -> void:
	for slot in inventory_slots:
		if (!slot.slot_filled):
			slot.fill_slot(mail_data)
			inventory_full = not has_free_slot()
			return
	inventory_full = true

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var slot: InventoryItem = inventory_slots[data]
	if (slot.slot_data == null):
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	drop_item(data)
	inventory_full = !has_free_slot()

func item_moving_slot(old_slot_index: int, new_slot_index: int) -> void:
	var new_slot_item: MailData = inventory_slots[new_slot_index].slot_data
	var old_slot_item: MailData = inventory_slots[old_slot_index].slot_data
	inventory_slots[new_slot_index].fill_slot(old_slot_item)
	inventory_slots[old_slot_index].fill_slot(new_slot_item)

func item_double_clicked(selected_index: int) -> void:
	var slot: InventoryItem = inventory_slots[selected_index]
	if (slot.slot_data == null):
		return
	match get_action_data(slot.slot_data):
		ActionData.ActionType.DELIVERABLE:
			print("Equipping item")

func item_right_clicked(selected_index: int) -> void:
	var slot: InventoryItem = inventory_slots[selected_index]
	if (slot.slot_data == null):
		return
	context_menu.clear()
	match get_action_data(slot.slot_data):
		ActionData.ActionType.DELIVERABLE:
			context_menu.add_item("View", 0)
			context_menu.add_item("Equip", 1)
			context_menu.add_item("Drop", 2)
	context_menu.set_meta("selected_index", selected_index)
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var rect: Rect2i = Rect2i(mouse_position.floor(), Vector2i(1,1))
	context_menu.popup(rect)

func _on_context_menu(id: int) -> void:
	var selected_index: int = context_menu.get_meta("selected_index")
	var slot: InventoryItem = inventory_slots[selected_index]
	if (slot.slot_data == null):
		return
	
	match get_action_data(slot.slot_data):
		ActionData.ActionType.DELIVERABLE:
			match id:
				0:
					view_item(selected_index)
				1:
					equip_item(selected_index)
				2:
					drop_item(selected_index)

func get_action_data(mail_data: MailData) -> ActionData.ActionType:
	if (mail_data == null or mail_data.item_model_prefab == null):
		return ActionData.ActionType.INVALID
	return mail_data.action_data.action_type

## inventory actions

func drop_item (selected_index: int) -> void:
	var slot: InventoryItem = inventory_slots[selected_index]
	if (slot.slot_data == null):
		return
	
	var instance = slot.slot_data.item_model_prefab.instantiate() as Node3D
	get_tree().current_scene.add_child(instance)
	
	# forward check
	var drop_distance: float = 2.0
	var forward_direction: Vector3 = -player_camera.global_transform.basis.z.normalized()
	var target_position: Vector3 = player_camera.global_transform.origin + forward_direction * drop_distance
	
	var space_state = hand.get_world_3d().direct_space_state
	
	# obstacle check
	var obstacle_parameters = PhysicsRayQueryParameters3D.new()
	obstacle_parameters.from = player_camera.global_transform.origin
	obstacle_parameters.to = target_position
	obstacle_parameters.exclude = [hand.get_parent()]
	
	var obstacle_hit: Dictionary = space_state.intersect_ray(obstacle_parameters)
	if (obstacle_hit):
		print("Object in the way, cannot drop.")
		return
	
	# finding the ground
	var ground_parameters = PhysicsRayQueryParameters3D.new()
	ground_parameters.from = target_position + Vector3.UP * 2.0
	ground_parameters.to = target_position - Vector3.UP * 5.0
	ground_parameters.exclude = [hand.get_parent()]
	
	var ground_hit: Dictionary = space_state.intersect_ray(ground_parameters)
	if (not ground_hit):
		print("No Ground to drop item onto.")
		return
	
	var ground_position: Vector3 = ground_hit.position
	
	# moving the item
	if (instance is RigidBody3D):
		instance.global_transform.origin = ground_position + Vector3.UP * 0.2
		instance.freeze = false
		instance.gravity_scale = 1.0
	else:
		instance.global_transform.origin = ground_position + Vector3.UP * 0.001
	instance.rotation_degrees.y = randf() * 360
	slot.fill_slot(null)
	inventory_full = not has_free_slot()

func view_item (selectedindex: int) -> void:
	var slot: InventoryItem = inventory_slots[selectedindex]
	if (slot.slot_data == null):
		return
	
	var instance = slot.slot_data.item_model_prefab.instantiate() as Node3D
	item_interaction.on_item_viewed(instance)
	slot.fill_slot(null)
	
func equip_item (selectedindex: int) -> void:
	var slot: InventoryItem = inventory_slots[selectedindex]
	if (slot.slot_data == null):
		return
	
	var instance = slot.slot_data.item_model_prefab.instantiate() as Node3D
	item_interaction.on_item_equipped(instance)
	slot.fill_slot(null)

## -- signal stuff
func send_inventory_to_submit_screen(submit_screen: SubmitMailScreen) -> void:
	print("inventory_slots size: ", inventory_slots.size())
	submit_screen.set_inventory_data(inventory_slots)
