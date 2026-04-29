extends Entity

class_name Player

@onready var wizardFlying : int = 0
@onready var Reputation : int = 0  
@onready var Slayer : int = 0
@onready var Collection : int = 0
@onready var Informant : int = 0
@onready var Courier : int = 0
@onready var Banker : int = 0
@onready var Entropy : int = 0
@onready var xp : int
@onready var xpToNextLevel : int
@onready var health : int



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		print("died")
	pass
	
func _init() -> void:
	xp = 0
	xpToNextLevel = 100
	
func gainXP(xpGain: int) -> void: #override later if class skills affect xp gain
	xp+= xpGain
	if xp >= xpToNextLevel:
		GameManager.playerLevel+=1
		GameManager.skillPoints+=1
		xp-=xpToNextLevel
		xpToNextLevel = 100 + (GameManager.playerLevel-1)*50 #temporary xp increase
