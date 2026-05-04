extends Node

@onready var skillPoints : int

@onready var Entropy : int
@onready var playerLevel : int
@onready var uiOpen : bool = false
@onready var npcQuests = [0,0,0,0,0,0,0,0]
@onready var player : Player
@onready var questsGenerated : bool
@onready var invinsibilityTime : float = 0.0
@onready var correctDeliveries : int
@onready var incorectDeliveries : int
@onready var deliveries : int
@onready var maxQuests : int = 4
@onready var minQuests : int = 1
@onready var endOfDayXp : int = 0

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

func _process(delta: float) -> void:
	if player.health <= 0:
		var protoController = get_tree().current_scene.find_child("ProtoController")
		protoController.position = Vector3(88.804, 0.1, 140.98)
		newDay()

func _ready() -> void:
	playerClass = PlayerClassTypes.NOCLASS
	skillPoints = 10000
	playerLevel = 1
	player = Player.new()
	newDay()

func newDay() -> void: #use this function to change what is needed when a new day starts
	deliveries = 0
	incorectDeliveries = 0
	correctDeliveries = 0
	player.health = player.max_health
	questsGenerated = false
	for i in range(npcQuests.size()):
		npcQuests[i] = 0
	var rand = RandomNumberGenerator.new()
	var numOfQuests = rand.randi_range(minQuests,maxQuests)
	var questRange = range(0,7)
	questRange.shuffle()
	questRange = questRange.slice(0,numOfQuests)
	for i in range(numOfQuests):
		npcQuests[questRange[i]] = 1
	print(npcQuests)
