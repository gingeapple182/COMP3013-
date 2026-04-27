extends Node

@onready var skillPoints : int

@onready var Entropy : int
@onready var playerLevel : int
@onready var uiOpen : bool = false
@onready var npcQuests = [0,0,0,0,0,0,0,0]
@onready var acceptedQuests = [0,0,0,0,0,0,0,0]
@onready var player : Player

enum PlayerClassTypes
{
	WIZARD,
	HERMIT,
	TYCOON,
	PALADIN,
	NOCLASS
}

@onready var playerClass : PlayerClassTypes



func _ready() -> void:
	playerClass = PlayerClassTypes.WIZARD
	skillPoints = 1
	playerLevel = 1
	if playerClass == PlayerClassTypes.HERMIT:
		player = Hermit.new()
	elif playerClass == PlayerClassTypes.TYCOON:
		player = Tycoon.new()
	elif playerClass == PlayerClassTypes.PALADIN:
		player = Paladin.new()
	elif playerClass == PlayerClassTypes.WIZARD:
		player = Wizard.new()
	else:
		player = Player.new()
	newDay()

func newDay() -> void: #use this function to change what is needed when a new day starts
	var rand = RandomNumberGenerator.new()
	var numOfQuests = rand.randi_range(2,6)
	var questRange = range(0,7)
	questRange.shuffle()
	questRange = questRange.slice(0,numOfQuests)
	for i in range(numOfQuests):
		npcQuests[questRange[i]] = 1
	print(npcQuests)
		
