extends Node

@onready var item_interaction: Node = %item_interaction
@onready var interaction_ray_cast: RayCast3D = %InteractionRayCast
@onready var player_camera: Camera3D = %Camera3D
@onready var marker_3d: Marker3D = %Marker3D
@onready var inventory_ui: Control = $"../../Inventory Controller/CanvasLayer/Inventory UI"

var current_object: Object
var last_object: Object
var interaction_component: Node

signal inventory_on_item_collected(item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_on_item_collected.connect(inventory_ui.pickup_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (current_object):
		if (Input.is_action_pressed("interact")):
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
					if (interaction_component.interaction_type == interaction_component.InteractionType.MAIL):
						interaction_component.connect("item_collected", Callable(self, "_on_item_collected"))

func _on_item_collected(item: Node):
	item.visible = false
	var item_component = find_interaction_component(item)
	_add_item_to_inventory(item_component.mail_data)
	item.queue_free()

func _add_item_to_inventory(mail_data: MailData) -> void:
	if (mail_data != null):
		inventory_on_item_collected.emit(mail_data)
		return
	
	print("item not found")

func find_interaction_component(node: Node) -> AbstractInteraction:
	while node:
		for child in node.get_children():
			if child is AbstractInteraction:
				return child
		node = node.get_parent()
	return null
