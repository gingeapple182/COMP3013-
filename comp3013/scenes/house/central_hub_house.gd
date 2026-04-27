extends Node3D

@onready var central_hub_tycoon_house: Node3D = $Extensions/CentralHubTycoonHouse
@onready var central_hub_wizard_tower: Node3D = $Extensions/CentralHubWizardTower
@onready var central_hub_cleric_chapel: Node3D = $Extensions/central_hub_cleric_chapel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	central_hub_tycoon_house.process_mode = 4
	central_hub_wizard_tower.process_mode = 4
	central_hub_cleric_chapel.process_mode = 4
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.playerClass == GameManager.PlayerClassTypes.PALADIN:
		central_hub_cleric_chapel.visible = true
		central_hub_cleric_chapel.process_mode = 0
	elif GameManager.playerClass == GameManager.PlayerClassTypes.WIZARD:
		central_hub_wizard_tower.visible = true
		central_hub_wizard_tower.process_mode = 0
	elif GameManager.playerClass == GameManager.PlayerClassTypes.TYCOON:
		central_hub_tycoon_house.visible = true
		central_hub_tycoon_house.process_mode = 0

	pass
