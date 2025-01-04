extends CharacterBody2D
class_name Player

const SPEED = 125.0
const SpellProjectile = preload("res://Scenes/spell_projectile.tscn")

var game = null;

var mana = 100.0

@onready var visual = $Visual
@onready var anim_sprite = $Visual/AnimatedSprite2D
@onready var anim_player = $Visual/AnimationPlayer
@onready var wand_tip = $Visual/WandTip

var state: PlayerState;

var last_velocity: Vector2;

var is_mouse_moving = false;

func _ready():
	state = PlayerState.CONTROLLED
	last_velocity = Vector2(0,0)

	game = GameManager.get_game()

func _physics_process(delta: float) -> void:
	if state == PlayerState.CONTROLLED:
		var x_direction := Input.get_axis("left", "right")
		var y_direction := Input.get_axis("up", "down")
		var direction := Vector2(x_direction, y_direction).normalized()

		if direction.length() > 0:
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED

			if abs(velocity.x) >= abs(velocity.y):
				anim_player.play("run_horizontal")
			else:
				if velocity.y < 0:
					anim_player.play("run_up")
				elif velocity.y > 0:
					anim_player.play("run_down")
				
			last_velocity = velocity

		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

			if abs(last_velocity.x) >= abs(last_velocity.y):
				anim_player.play("idle_horizontal")
			else:
				if last_velocity.y < 0:
					anim_player.play("idle_up")
				elif last_velocity.y > 0:
					anim_player.play("idle_down")

		if direction.x < 0:
			# anim_sprite.flip_h = true
			visual.scale.x = -1
		elif direction.x > 0:
			# anim_sprite.flip_h = false
			visual.scale.x = 1

		move_and_slide()



func _process(delta):
	if state  == PlayerState.CONTROLLED:
		if Input.is_action_just_pressed("interact"):
			GameManager.interact()
			print("interacting")

		if Input.is_action_just_pressed("fire"):
			var mouse_pos: Vector2 = get_global_mouse_position()

			# intantiating a spell projectile and setting its position to the want tip
			var spell = SpellProjectile.instantiate()

			game.add_child(spell)
			spell.global_position = wand_tip.global_position
			

			var direction: Vector2 = (mouse_pos - wand_tip.global_position).normalized()

			spell.send(direction, 250) # sending the spell

			print("fire")

		if velocity.length() > 0 || is_mouse_moving:
			var space_state = get_world_2d().direct_space_state
			# use global coordinates, not local to node
			var query = PhysicsRayQueryParameters2D.create(wand_tip.global_position, get_global_mouse_position(), 85)
			var result = space_state.intersect_ray(query)

			if result:
				game.show_crosshair(result.position)
			else:
				game.hide_crosshair()

		is_mouse_moving = false

func _input(event: InputEvent) -> void:
	if state == PlayerState.CONTROLLED:
		if event is InputEventMouseMotion:
			is_mouse_moving = true

		




func change_state(new_state: PlayerState):
	state = new_state

enum PlayerState { RESTING, CONTROLLED }

enum Ability { TEMP, TIME_DIALATE, OCCUPY }