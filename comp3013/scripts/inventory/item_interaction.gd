extends Node

@onready var item_interaction: Node = %item_interaction
@onready var interaction_ray_cast: RayCast3D = %InteractionRayCast
@onready var player_camera: Camera3D = %Camera3D
@onready var marker_3d: Marker3D = %Marker3D

var current_object: Object
var last_object: Object
var interaction_component: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (current_object):
		if (Input.is_action_just_pressed("interact")):
			if (interaction_component):
				interaction_component.interact()
		else:
			if (interaction_component):
				interaction_component.postInteract()
				current_object = null
	
	else:
		var cast_object: Object = interaction_ray_cast.get_collider()
		if (cast_object and cast_object is Node):
			interaction_component = cast_object.get_node_or_null("interaction_component")
			if (interaction_component):
				if (interaction_component.can_interact == false):
					return
					
				last_object = current_object
				if (Input.is_action_just_pressed("interact")):
					current_object = cast_object
					interaction_component.preInteract(marker_3d)
