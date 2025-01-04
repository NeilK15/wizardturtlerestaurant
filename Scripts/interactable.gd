extends Area2D
class_name Interactable

@export var tooltip: Control

var show_tooltip;

signal interact

func _ready():
	show_tooltip = true
	if tooltip:
		tooltip.visible = false

func _on_mouse_entered() -> void:
	GameManager.over_interactable(self)
	if tooltip and show_tooltip:
		tooltip.visible = true

func _on_mouse_exited() -> void:
	GameManager.left_interactable(self)
	if tooltip:
		tooltip.visible = false

func interact_with():
	interact.emit()
