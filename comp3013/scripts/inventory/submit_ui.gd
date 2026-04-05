extends Control

class_name SubmitMailScreen

# -- signals -- '
signal inventory_requested
signal submit_requested(mail_data: MailData, npc: NPC)
signal cancel_requested

# -- export stuff -- #
@export_group("UI References")
@export var inventory_grid: GridContainer
@export var submit_grid: GridContainer
@export var npc_name_label: Label
@export var npc_request_label: Label

@export_group("Settings")
@export var item_slots_count: int = 20
@export var inventory_slot_prefab: PackedScene = preload("res://scripts/inventory/inventory_item.tscn")

@onready var submit_ui: SubmitMailScreen = $"."

var display_inventory_slots: Array[InventoryItem] = []
var submit_slot: InventoryItem = null

var source_inventory_slots: Array[InventoryItem] = []
var selected_mail_data: MailData = null
var selected_inventory_index: int = -1
var current_npc: NPC = null


func _ready() -> void:
	visible = false
	_build_inventory_display()
	_build_submit_slot()


func _build_inventory_display() -> void:
	_clear_container(inventory_grid)
	display_inventory_slots.clear()

	for i in range(item_slots_count):
		var slot := inventory_slot_prefab.instantiate() as InventoryItem
		inventory_grid.add_child(slot)

		slot.slot_index = i
		display_inventory_slots.append(slot)

		# Connect click handling directly to each visual slot
		if slot is Control:
			slot.gui_input.connect(_on_inventory_slot_gui_input.bind(i))


func _build_submit_slot() -> void:
	_clear_container(submit_grid)

	submit_slot = inventory_slot_prefab.instantiate() as InventoryItem
	submit_grid.add_child(submit_slot)
	submit_slot.slot_index = 0
	submit_slot.fill_slot(null)


func open_screen(npc: NPC, inventory_slots: Array[InventoryItem]) -> void:
	current_npc = npc
	#source_inventory_slots = inventory_slots
	selected_mail_data = null
	selected_inventory_index = -1
	
	visible = true
	#_refresh_inventory_display()
	_clear_submit_slot()
	_update_npc_info()
	inventory_requested.emit()


func close_screen() -> void:
	visible = false

	current_npc = null
	#source_inventory_slots.clear()
	source_inventory_slots = []
	selected_mail_data = null
	selected_inventory_index = -1

	_clear_submit_slot()
	_clear_inventory_display()
	_clear_npc_info()


func _refresh_inventory_display() -> void:
	for i in range(display_inventory_slots.size()):
		var display_slot := display_inventory_slots[i]

		if i < source_inventory_slots.size():
			var source_slot := source_inventory_slots[i]

			if source_slot.slot_data != null:
				display_slot.fill_slot(source_slot.slot_data)
			else:
				display_slot.fill_slot(null)
		else:
			display_slot.fill_slot(null)


func _clear_inventory_display() -> void:
	for slot in display_inventory_slots:
		slot.fill_slot(null)


func _clear_submit_slot() -> void:
	if submit_slot != null:
		submit_slot.fill_slot(null)


func _update_npc_info() -> void:
	if current_npc == null:
		_clear_npc_info()
		return

	if npc_name_label != null:
		npc_name_label.text = current_npc.name_label.text

	if npc_request_label != null:
		npc_request_label.text = "Expected item: TBC"


func _clear_npc_info() -> void:
	if npc_name_label != null:
		npc_name_label.text = ""

	if npc_request_label != null:
		npc_request_label.text = ""


func _on_inventory_slot_gui_input(event: InputEvent, slot_index: int) -> void:
	if not visible:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_select_inventory_item(slot_index)


func _select_inventory_item(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= display_inventory_slots.size():
		return

	var clicked_slot := display_inventory_slots[slot_index]

	if clicked_slot.slot_data == null:
		selected_inventory_index = -1
		selected_mail_data = null
		_clear_submit_slot()
		return

	selected_inventory_index = slot_index
	selected_mail_data = clicked_slot.slot_data

	if submit_slot != null:
		submit_slot.fill_slot(selected_mail_data)


func set_inventory_data(inventory_slots: Array[InventoryItem]) -> void:
	print("received inventory size: ", inventory_slots.size())
	source_inventory_slots = inventory_slots.duplicate()
	_refresh_inventory_display()

func get_selected_mail_data() -> MailData:
	return selected_mail_data


func get_selected_inventory_index() -> int:
	return selected_inventory_index


func has_selected_item() -> bool:
	return selected_mail_data != null


func _clear_container(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()


func _on_button_cancel_pressed() -> void:
	submit_ui.visible = false
	GameManager.uiOpen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#mouse_captured = true


func _on_button_submit_pressed() -> void:
	if current_npc == null:
		print("No NPC selected.")
		return
	
	if selected_mail_data == null:
		print("No item selected.")
		return
	
	current_npc.start_kill()
	print("Submitted item to: ", current_npc.npc_name)
	
	close_screen()
	GameManager.uiOpen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
