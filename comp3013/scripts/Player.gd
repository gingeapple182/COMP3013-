extends Entity

class_name Player


@onready var skillPoints : int = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init() -> void:
	skillPoints = 5

