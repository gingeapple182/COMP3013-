extends Node

@onready var timer: Timer = $HealthBar/Timer
@onready var health_bar: ProgressBar = $HealthBar
@onready var damage_bar: ProgressBar = $HealthBar/DamageBar
@onready var xp_bar: ProgressBar = $XpBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health_bar.value != GameManager.player.health:
		health_bar.value = GameManager.player.health
		timer.start()
	if health_bar.max_value != GameManager.player.max_health:
		health_bar.max_value = GameManager.player.max_health
	if xp_bar.value != GameManager.player.xp:
		xp_bar.value = GameManager.player.xp
	if xp_bar.max_value != GameManager.player.xpToNextLevel:
		xp_bar.max_value= GameManager.player.xpToNextLevel

func _on_timer_timeout() -> void:
	damage_bar.value = health_bar.value
