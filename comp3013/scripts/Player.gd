extends Entity

class_name Player

@onready var xp : int
@onready var xpToNextLevel : int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init() -> void:
	GameManager.className = "Hermit"
	xp = 0
	xpToNextLevel = 100
	
func gainXP(xpGain: int) -> void: #override later if class skills affect xp gain
	xp+= xpGain
	if xp >= xpToNextLevel:
		GameManager.playerLevel+=1
		GameManager.skillPoints+=1
		xp-=xpToNextLevel
		xpToNextLevel = 100 + (GameManager.playerLevel-1)*50 #temporary xp increase
