extends Node3D
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var deliveries_label: Label = $CanvasLayer/EndOfDayResults/TextureRect/Deliveries/Label
@onready var correct_deliveries_label: Label = $"CanvasLayer/EndOfDayResults/TextureRect/Correct deliveries/Label"
@onready var incorrect_deliveries_label: Label = $"CanvasLayer/EndOfDayResults/TextureRect/Incorrect deliveries/Label"
@onready var confirm: CanvasLayer = $Confirm

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.uiOpen = true
	deliveries_label.text = str(GameManager.deliveries)
	correct_deliveries_label.text = str(GameManager.correctDeliveries)
	incorrect_deliveries_label.text = str(GameManager.incorectDeliveries)
	print("showing")
	confirm.show()
