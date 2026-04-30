extends Node

@onready var skillPoints : int

@onready var Entropy : int
@onready var playerLevel : int
@onready var uiOpen : bool = false
@onready var npcQuests = [0,0,0,0,0,0,0,0]
@onready var player : Player
@onready var questsGenerated : bool

enum PlayerClassTypes
{
	WIZARD,
	HERMIT,
	TYCOON,
	PALADIN,
	NOCLASS
}

@onready var playerClass : PlayerClassTypes

@onready var npcs: Node = $NPCs


func _ready() -> void:
	playerClass = PlayerClassTypes.NOCLASS
	skillPoints = 10000
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
	questsGenerated = false
	for i in range(npcQuests.size()):
		npcQuests[i] = 0
	var rand = RandomNumberGenerator.new()
	var numOfQuests = rand.randi_range(2,6)
	var questRange = range(0,7)
	questRange.shuffle()
	questRange = questRange.slice(0,numOfQuests)
	for i in range(numOfQuests):
		npcQuests[questRange[i]] = 1
	print(npcQuests)
