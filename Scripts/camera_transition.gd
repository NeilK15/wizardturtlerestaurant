extends Node


@onready var camera2D: Camera2D = $Camera2D

var transitioning: bool = false

func _ready() -> void:
	camera2D.enabled = false

func switch_camera(from, to) -> void:
	from.current = false
	to.current = true

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	camera2D.zoom = from.zoom
	camera2D.offset = from.offset
	camera2D.light_mask = from.light_mask
	
	# Move our transition camera to the first camera position
	camera2D.global_transform = from.global_transform
	
	# Make our transition camera current
	from.enabled = false
	to.enabled = false
	camera2D.enabled = true
	camera2D.make_current()
	
	transitioning = true

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera2D, "global_transform", to.global_transform, duration).from(camera2D.global_transform)
	tween.tween_property(camera2D, "zoom", to.zoom, duration).from(camera2D.zoom)
	tween.tween_property(camera2D, "offset", to.offset, duration).from(camera2D.offset)

	# Wait for the tween to complete
	
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	# tween.remove_all()
	# tween.interpolate_property(camera2D, "global_transform", camera2D.global_transform, 
	# 	to.global_transform, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	# tween.interpolate_property(camera2D, "zoom", camera2D.zoom, 
	# 	to.zoom, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	# tween.interpolate_property(camera2D, "offset", camera2D.offset, 
	# 	to.offset, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	# tween.start()
	

	await tween.finished

	# Wait for the tween to complete
	# yield(tween, "tween_all_completed")
	
	# Make the second camera current
	camera2D.enabled = false
	to.enabled = true
	to.make_current()
	transitioning = false
