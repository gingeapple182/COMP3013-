extends Control
class_name InventoryItem

@onready var item_icon: TextureRect = $TextureRect

var slot_index: int = -1
var slot_filled: bool = false
var slot_data: MailData

signal on_item_swapped(old_slot_index: int, new_slot_index: int)
signal on_item_double_clicked(selected_index:int)
signal on_item_right_clicked(selected_index:int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_slot(mail_data: MailData) -> void:
	slot_data = mail_data
	if (slot_data != null):
		slot_filled = true
		item_icon.texture = mail_data.item_icon
	else:
		slot_filled = false
		item_icon.texture = null

func _get_drag_data(at_position: Vector2) -> Variant:
	if (slot_filled):
		var preview: TextureRect = TextureRect.new()
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#preview.size = item_icon.size
		preview.pivot_offset = item_icon.size / 2.0
		preview.texture = item_icon.texture
		set_drag_preview(preview)
		return slot_index
	return null
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_INT

func _drop_data(at_position: Vector2, data: Variant) -> void:
	on_item_swapped.emit(data, slot_index)

func _gui_input(event: InputEvent) -> void:
	if (!slot_filled):
		return
	
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT and event.double_click):
			on_item_double_clicked.emit(slot_index)
		elif (event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
			on_item_right_clicked.emit(slot_index)
			
			
