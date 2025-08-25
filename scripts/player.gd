extends CharacterBody2D

@export var SPEED : float = 225.0

@onready var cam: Camera2D = $Camera2D
var syncPos = Vector2(0,0)

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if cam and is_multiplayer_authority():
		cam.make_current()

func _physics_process(_delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var vx := Input.get_axis("ui_left","ui_right") * SPEED
		var vy := Input.get_axis("ui_up","ui_down") * SPEED
		velocity.x = vx if (abs(vx) > 0.0) else move_toward(velocity.x, 0.0, SPEED)
		velocity.y = vy if (abs(vy) > 0.0) else move_toward(velocity.y, 0.0, SPEED)
		syncPos = global_position
		move_and_slide()
