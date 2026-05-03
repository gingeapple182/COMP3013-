extends ProgressBar

@onready var timer: Timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar
@onready var xp_bar: ProgressBar = $"../XpBar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.value != GameManager.player.health:
		self.value = GameManager.player.health
		timer.start()
	if self.max_value != GameManager.player.max_health:
		self.max_value = GameManager.player.max_health
	if xp_bar.value != GameManager.player.xp:
		xp_bar.value = GameManager.player.xp
	if xp_bar.max_value != GameManager.player.xpToNextLevel:
		xp_bar.max_value= GameManager.player.xpToNextLevel

func _on_timer_timeout() -> void:
	damage_bar.value = self.value
