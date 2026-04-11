extends TextureButton
@onready var label: Label = $"../Label"
@onready var pinboard_item: Control = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	GameManager.acceptedQuests[int(label.text)] = 1
	pinboard_item.queue_free()
	pass # Replace with function body.
