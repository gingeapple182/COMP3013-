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



func _ready() -> void:
	skillPoints = 5
