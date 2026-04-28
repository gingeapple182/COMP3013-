extends TextureButton

class_name SkillTreeButton

@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line_2d = $Line2D
@onready var texture_rect: TextureRect = $TextureRect

@onready var skill_tree: Control = $".."
@export var maxLevel : int

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/"+ str(maxLevel)


func _ready():
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
			line_2d.clear_points()
			line_2d.add_point(Vector2(global_position.x + size.x/2, global_position.y + size.y))
			line_2d.add_point(Vector2(get_parent().global_position.x + size.x/2, get_parent().global_position.y))


func _on_pressed() -> void:
	if GameManager.skillPoints == 0:
		return
	if level < 3:
		GameManager.skillPoints -= 1
		level = min(level+1, 3)
	panel.show_behind_parent = true
	line_2d.default_color = Color(0.0, 1.0, 0.0, 1.0)
	texture_rect.visible = false
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillTreeButton and level == 1:
			skill.disabled = false
			skill.texture_rect.visible = true
