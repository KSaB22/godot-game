extends CharacterBody2D

@export var SPEED: float = 500.0
var direction := Vector2.ZERO

func _ready() -> void:
	# Face to the right by default; rotate that by our current rotation
	direction = Vector2.RIGHT.rotated(global_rotation)

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()
