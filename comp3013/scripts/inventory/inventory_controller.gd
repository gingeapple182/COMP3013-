extends Control

var item_slots_count: int = 20
var inventory_slot_prefab: PackedScene = load("res://scripts/inventory/inventory_item.tscn")
@onready var inventory_grid: GridContainer = %GridContainer
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
			
func item_moving_slot(old_slot_index: int, new_slot_index: int) -> void:
	var new_slot_item: MailData = inventory_slots[new_slot_index].slot_data
	var old_slot_item: MailData = inventory_slots[old_slot_index].slot_data
	inventory_slots[new_slot_index].fill_slot(old_slot_item)
	inventory_slots[old_slot_index].fill_slot(new_slot_item)

func item_double_clicked(selected_index: int) -> void:
	return

func item_right_clicked(selected_index: int) -> void:
	return
