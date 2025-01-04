extends CharacterBody2D


const SPEED = 75.0

@onready var anim_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var interactable = $Interactable
@onready var nav_agent = $NavigationAgent2D

var state = TurtleState.AI
var movement_target_position = null

func _ready():
	var nav_machine := GameManager.get_nav_machine()
	movement_target_position = nav_machine.get_order_counter_pos()
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	nav_agent.target_position = movement_target


func _physics_process(delta: float) -> void:

	if state == TurtleState.AI:
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
			return

		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * SPEED

	elif state == TurtleState.CONTROLLED:
		var x_direction := Input.get_axis("left", "right")
		var y_direction := Input.get_axis("up", "down")
		var direction := Vector2(x_direction, y_direction).normalized()

		if direction.length():
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED

			# anim_sprite.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

			# anim_sprite.play("idle")

		# if direction.x < 0:
		# 	anim_sprite.flip_h = true
		# elif direction.x > 0:
		# 	anim_sprite.flip_h = false

	move_and_slide()


func update_ai():
	set_movement_target(movement_target_position)

func _process(delta):
	if state == TurtleState.AI:
		pass
	elif state == TurtleState.CONTROLLED:
		if Input.is_action_just_pressed("interact"):
			# deactivate control of turtle
			state = TurtleState.AI
			# ensure turtle AI gets updated
			update_ai()

			await get_tree().process_frame

			interactable.show_tooltip = true

			# activate control of player
			await GameManager.activate_player(camera)

	if velocity.length() > 0:
		anim_sprite.play("run")
	else:
		anim_sprite.play("idle")

	if velocity.x < 0:
		anim_sprite.flip_h = true
	if velocity.x > 0:
		anim_sprite.flip_h = false

func _on_interactable_interact() -> void:
	# deactivate control of player
	await GameManager.deactivate_player(camera)

	await get_tree().process_frame

	interactable.show_tooltip = false

	# activate control of turtle
	state = TurtleState.CONTROLLED


enum TurtleState {AI, CONTROLLED}