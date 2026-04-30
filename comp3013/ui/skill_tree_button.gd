extends TextureButton

class_name SkillTreeButton

@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line_2d = $Line2D
@onready var texture_rect: TextureRect = $TextureRect

@onready var skill_tree: Control = $".."
@export var maxLevel : int

@export var level : int
	
enum ClassSkill
{
	WIZARD,
	HERMIT,
	TYCOON,
	PALADIN,
	NOCLASS
}
@export var class_Skill: GameManager.PlayerClassTypes = GameManager.PlayerClassTypes.NOCLASS

func _ready():
	if level > 0:
		panel.show_behind_parent = true
		var skills = get_children()
		for skill in skills:
			if skill is SkillTreeButton and level == 1:
				skill.disabled = false
				skill.texture_rect.visible = true
	label.text = str(level) + "/"+ str(maxLevel)
	if get_parent() is SkillTreeButton:
		line_2d.add_point(Vector2(global_position.x + size.x/2, global_position.y + size.y))
		line_2d.add_point(Vector2(get_parent().global_position.x + size.x/2, get_parent().global_position.y))
	if !disabled && level == 0:
		texture_rect.visible = true
		
	#checking if parent is SkillTree in order to be able to access the scrpit attached to it
	#cant reference it because it will be in a differnet place for each button
	var skillButton = self	
	while skillButton.get_parent().name != "SkillTree": 
		skillButton = skillButton.get_parent()
	skill_tree = skillButton.get_parent()
	
func _process(delta: float) -> void:
	if get_parent() is SkillTreeButton:
		if GameManager.playerClass != class_Skill && class_Skill != GameManager.PlayerClassTypes.NOCLASS && GameManager.playerClass !=GameManager.PlayerClassTypes.NOCLASS :
			#print(GameManager.PlayerClassTypes.keys()[GameManager.playerClass])
			texture_rect.texture = null
		line_2d.clear_points()
		line_2d.add_point(Vector2(global_position.x + size.x/2, global_position.y + size.y))
		line_2d.add_point(Vector2(get_parent().global_position.x + size.x/2, get_parent().global_position.y))


func _on_pressed() -> void:
	if GameManager.skillPoints == 0:
		return
	if class_Skill != GameManager.PlayerClassTypes.NOCLASS && GameManager.playerClass == GameManager.PlayerClassTypes.NOCLASS:
		GameManager.playerClass = class_Skill
	if GameManager.playerClass != class_Skill && class_Skill != GameManager.PlayerClassTypes.NOCLASS:
		print("return")
		print(GameManager.PlayerClassTypes.keys()[GameManager.playerClass])
		return

	if level < maxLevel:
		panel.show_behind_parent = true
		GameManager.skillPoints -= 1
		level = min(level+1, maxLevel)
		set_Skill_Level()
	line_2d.default_color = Color(0.0, 1.0, 0.0, 1.0)
	texture_rect.visible = false
		
	var skills = get_children()
	for skill in skills:
		if skill is SkillTreeButton and level == 1 and skill.level == 0:
			skill.disabled = false
			skill.texture_rect.visible = true

func set_Skill_Level() -> void: #tycoongen xp, wizardgen movespeed, paladingen carryweight, hermit npcSize, gen deftault to on
	label.text = str(level) + "/"+ str(maxLevel)
	print(level)
	match self.name:
		"WizardGen":
			GameManager.player.movementSpeedSkill = level
		"PaladinGen":
			GameManager.player.carryWeight = 10 + level * 5
		"TycoonGen":
			GameManager.player.xpMultiplier = level
		"HermitGen":
			for npc in 	get_tree().current_scene.get_child(0).get_children():
				npc.scale = Vector3(1.0 + level*0.1, 1.0 + level*0.1, 1.0 + level*0.1)
