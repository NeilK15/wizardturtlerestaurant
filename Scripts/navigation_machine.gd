class_name NavigationMachine
extends Node2D


@export var nav_region: NavigationRegion2D
@export var order_counter: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_order_counter_pos() -> Vector2:
	return order_counter.position