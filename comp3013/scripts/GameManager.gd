extends Node

@onready var skillPoints : int

@onready var Entropy : int
@onready var Reputation : int  
@onready var Slayer : int
@onready var Courier : int
@onready var Banker : int
@onready var Collection : int
@onready var Informant : int
@onready var className : String
@onready var playerLevel : int
@onready var uiOpen : bool = false
@onready var npcQuests = [0,0,0,0,0,0,0,0]
@onready var acceptedQuests = [0,0,0,0,0,0,0,0]
@onready var player : Player


func _ready() -> void:
	skillPoints = 1
	playerLevel = 1
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
		
