extends CharacterBody2D

@export var speed: float = 500.0
@export var damage: int = 10

var direction: Vector2 = Vector2.ZERO
var is_player_projectile: bool = false

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		print("Collided")
		var collider = collision.get_collider()
		
		if is_player_projectile:
			# Player projectile: only damage enemies
			if collider.has_method("take_damage"):
				collider.take_damage(damage)
		else:
			# Enemy projectile: only damage players
			if collider.is_in_group("player"):
				if collider.has_method("take_damage"):
					collider.take_damage(damage)
		queue_free()
