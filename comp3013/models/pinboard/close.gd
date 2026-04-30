extends TextureButton

@onready var canvas_layer: CanvasLayer = $"../.."
@onready var grid_container: GridContainer = $"../GridContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	#for gridItem in grid_container.get_children():
		#gridItem.queue_free()
	GameManager.uiOpen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	canvas_layer.hide()
