extends Node2D


class_name Game
# @onready var player = preload("res://Scenes/player.tscn")

# var curr_interactable: Interactable = null

@onready var target_crosshair = $TargetCrosshair
@export var nav_machine: NavigationMachine

var crosshairs: SpriteFrames = load("res://Art/sprites/new_sprite_frames.tres")
var regular: Texture2D = null

# # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	regular = crosshairs.get_frame_texture("default", 0)

	Input.set_custom_mouse_cursor(regular, 0, Vector2(8,8))

func show_crosshair(pos: Vector2):
	target_crosshair.visible = true
	target_crosshair.position = pos
	pass

func hide_crosshair():
	target_crosshair.visible = false

func get_nav_machine() -> NavigationMachine:
	return nav_machine

func _process(delta: float) -> void:
	# logic for showing the target
	pass
