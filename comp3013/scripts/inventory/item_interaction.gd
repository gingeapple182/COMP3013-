extends Node

@onready var player_controller: CharacterBody3D = $".."

@onready var interact_text: Label = %InteractText

@onready var item_interaction: Node = %item_interaction
@onready var interaction_ray_cast: RayCast3D = %InteractionRayCast
@onready var player_camera: Camera3D = %Camera3D
@onready var hand: Marker3D = %main_hand
@onready var envelope_hand: Marker3D = %envelope_hand
@onready var equipped_hand: Marker3D = %equipped_hand

@onready var inventory_ui: Control = $"../Inventory Controller/CanvasLayer/Inventory UI"
@onready var mail_address: Control = %MailAddress
@onready var address_content: RichTextLabel = %AddressContent

var current_envelope: RigidBody3D
var envelope_interaction_component: InteractionComponent

var current_object: Object
var last_object: Object
var interaction_component: Node
signal inventory_on_item_collected(item)

var item_equipped: bool = false
var equipped_item: Node3D
var equipped_item_component: AbstractInteraction

var viewed_item: Node3D
var viewed_item_component: AbstractInteraction
var address_overlay_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact_text.hide()
	mail_address.visible = false
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
		if (cast_object and cast_object is Node and !GameManager.uiOpen):
			interaction_component = cast_object.get_node_or_null("interaction_component")
			if (interaction_component):
				#interact_text.show()
				if (interaction_component.can_interact == false):
					return
					
				last_object = current_object
				if (Input.is_action_just_pressed("interact")):
					current_object = cast_object
					interaction_component.preInteract(hand)
					if (interaction_component.interaction_type == interaction_component.InteractionType.MAIL):
						interaction_component.connect("item_collected", Callable(self, "_on_item_collected"))
			#else:
				#interact_text.hide()
		#else:
			#interact_text.hide()

func _input(event: InputEvent) -> void:
	if (address_overlay_active and event.is_action_pressed("interact")):
		mail_address.visible = false
		address_overlay_active = false
		var envelopes = envelope_hand.get_children()
		for envelope in envelopes:
			envelope.visible = false
			var item_component = find_interaction_component(envelope)
			_add_item_to_inventory(item_component.mail_data)
			envelope.queue_free()
	
	if (item_equipped and event.is_action_pressed("interact")):
		## Insert code to interact with NPCs
		return

func _on_item_collected(item: Node):
	if item is RigidBody3D:
		item.freeze = true
		item.linear_velocity = Vector3.ZERO
		item.angular_velocity = Vector3.ZERO
		item.gravity_scale = 0.0
	
	item.get_parent().remove_child(item)
	envelope_hand.add_child(item)
	
	viewed_item = item
	viewed_item_component = find_interaction_component(viewed_item)
	address_content.text = viewed_item_component.content
	
	mail_address.visible = true
	address_overlay_active = true
	
	item.transform.origin = envelope_hand.transform.origin
	item.position = Vector3(0, 0, 0)
	item.rotation = Vector3(90, 10, 0)

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

func on_item_viewed(item: Node3D) -> void:
	if item is RigidBody3D:
		item.freeze = true
		item.linear_velocity = Vector3.ZERO
		item.angular_velocity = Vector3.ZERO
		item.gravity_scale = 0.0
	
	if (item.get_parent() != null):
		item.get_parent().remove_child(item)
	else:
		var mesh = item.find_child("MeshInstance3D", true, false)
		if mesh:
			mesh.layers = 2
		var collider = item.find_child("CollisionShape3D", true, false)
		if collider:
			collider.get_parent().remove_child(collider)
			collider.queue_free()
			
	envelope_hand.add_child(item)
	
	viewed_item = item
	viewed_item_component = find_interaction_component(viewed_item)
	address_content.text = viewed_item_component.content
	
	mail_address.visible = true
	address_overlay_active = true
	player_controller.toggle_inventory()
	
	item.transform.origin = envelope_hand.transform.origin
	item.position = Vector3(0,0,0)
	item.rotation_degrees = Vector3(90, 10, 0)

func on_item_equipped(item: Node3D) -> void:
	if item is RigidBody3D:
		item.freeze = true
		item.linear_velocity = Vector3.ZERO
		item.angular_velocity = Vector3.ZERO
		item.gravity_scale = 0.0
	
	if (item.get_parent() != null):
		item.get_parent().remove_child(item)
	else:
		var mesh = item.find_child("MeshInstance3D", true, false)
		if mesh:
			mesh.layers = 2
		var collider = item.find_child("CollisionShape3D", true, false)
		if collider:
			collider.get_parent().remove_child(collider)
			collider.queue_free()
			
	equipped_hand.add_child(item)
	item.transform.origin = equipped_hand.transform.origin
	item.position = Vector3(0,0,0)
	item.rotation_degrees = Vector3(90, 10, 90)
	
	item_equipped = true
	equipped_item = item
	equipped_item_component = find_interaction_component(equipped_item)

#for 3d objects in scenes
#objects must be on collision layer 2 to be picked up by raycast
func _physics_process(delta):
	if GameManager.uiOpen:
		return
	var target = %InteractionRayCast.get_collider()
	if target != null && target.has_method("interact"):
		interact_text.show()
		if Input.is_action_just_pressed("interact"):
			target.interact()
			interact_text.hide()

	else:
		interact_text.hide()
	
