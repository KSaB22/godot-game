extends CharacterBody2D

@export var speed: float = 500.0
@export var damage: int = 10

var direction: Vector2 = Vector2.ZERO
var is_player_projectile: bool = false

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)

func _physics_process(delta):
	global_position += direction * speed * delta
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_player_projectile:
		if body.has_method("take_damage"):
			body.take_damage(damage)
	else:
		# Enemy projectile: only damage players
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
		elif body.is_in_group("enemy"):
			return
	queue_free()
