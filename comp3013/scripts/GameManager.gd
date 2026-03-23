extends Node

@onready var skillPoints : int

@onready var Entropy : bool 
@onready var Reputation : bool  
@onready var Slayer : bool 
@onready var Courier : bool
@onready var Banker : bool
@onready var Collection : bool
@onready var Informant : bool
@onready var className : String
@onready var playerLevel : int



func _ready() -> void:
	skillPoints = 5
