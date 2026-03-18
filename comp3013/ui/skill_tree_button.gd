extends TextureButton

class_name SkillTreeButton

@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line_2d = $Line2D


func _ready():
	if get_parent() is SkillTreeButton:
		line_2d.add_point(Vector2(global_position.x + size.x/2, global_position.y + size.y))
		line_2d.add_point(Vector2(get_parent().global_position.x + size.x/2, get_parent().global_position.y))
		print("1")



var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/3"


func _on_pressed() -> void:
	level = min(level+1, 3)
	panel.show_behind_parent = true
	line_2d.default_color = Color(0.0, 1.0, 0.0, 1.0)
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillTreeButton and level == 1:
			skill.disabled = false
