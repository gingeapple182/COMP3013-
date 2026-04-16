extends Player

class_name Paladin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func gainXP(xpGain : int) -> void:
	xp+= xpGain + xpGain *0.1*Reputation
	if xp >= xpToNextLevel:
		GameManager.playerLevel+=1
		GameManager.skillPoints+=1
		xp-=xpToNextLevel
		xpToNextLevel = 100 + (GameManager.playerLevel-1)*50 #temporary xp increase
