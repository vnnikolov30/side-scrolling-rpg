extends StaticBody2D
var baloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent
var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

func on_interactable_activated()->void:
	interactable_label_component.show()
	in_range = true
	print("Activated")

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false
	print("Deactivated")

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			var balloon: BaseGameDialogueBalloon = baloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/statue.dialogue"), "start")
