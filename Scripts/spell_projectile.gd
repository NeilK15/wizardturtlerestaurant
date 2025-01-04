extends RigidBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var trail: GPUParticles2D = $TrailParticles
@onready var explosion: GPUParticles2D = $ExplosionParticle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Spell package/show_in_app_libraryrojectile spawned")

	contact_monitor = true
	max_contacts_reported = 1
	print(collision_mask)


func send(direction: Vector2, force: float):
	apply_impulse(direction.normalized() * force)

enum SpellType {TEMP, TIME_DIALATE, OCCUPY}

func _on_body_entered(body:Node) -> void:
	freeze = true # freese the projectile
	trail.emitting = false
	explosion.emitting = true
	print("Colliding with " + body.name)


func _on_explosion_particle_finished() -> void:
	# once explosion is finished, destroy the instance
	queue_free()
