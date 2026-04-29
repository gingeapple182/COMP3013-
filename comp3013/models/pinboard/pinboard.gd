extends StaticBody3D
@onready var canvas_layer: CanvasLayer = $model/CanvasLayer
@onready var pinboardItem = preload("res://models/pinboard/pinboardItem.tscn")
@onready var grid_container: GridContainer = $model/CanvasLayer/TextureRect/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact() -> void:
	print("Interact")
	for i in range(GameManager.npcQuests.size()):
		if GameManager.npcQuests[i] == 1:
			var Item = pinboardItem.instantiate()
			Item.get_child(0).get_child(1).text = str(get_tree().current_scene.get_child(0).get_child(i).name)
			grid_container.add_child(Item)
	canvas_layer.show()
	GameManager.uiOpen = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
