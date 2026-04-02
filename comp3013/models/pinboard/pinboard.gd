extends StaticBody3D
@onready var canvas_layer: CanvasLayer = $model/CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact() -> void:
	print("Interact")
	canvas_layer.show()
	GameManager.uiOpen = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
