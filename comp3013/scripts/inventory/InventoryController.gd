extends Control
class_name InventoryController

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
		inventory_slots.append(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
