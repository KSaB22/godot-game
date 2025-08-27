extends CharacterBody2D

@export var SPEED: float = 225.0
@export var projectile: PackedScene

@onready var cam: Camera2D = $Camera2D
@onready var weapon: Node2D = $WeaponRotation
@onready var muzzle: Node2D = $WeaponRotation/ProjectileSpawn

var syncedHP := 100.0
var syncPos := Vector2.ZERO
var syncRot := 0.0

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if cam and is_multiplayer_authority():
		cam.make_current()

func _physics_process(_delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Aim the weapon at the mouse (global coords)
		weapon.look_at(get_global_mouse_position())
		syncRot = weapon.rotation # radians

		if Input.is_action_just_pressed("Fire"):
			fire.rpc()

		var vx := Input.get_axis("ui_left","ui_right") * SPEED
		var vy := Input.get_axis("ui_up","ui_down") * SPEED
		velocity.x = vx if abs(vx) > 0.0 else move_toward(velocity.x, 0.0, SPEED)
		velocity.y = vy if abs(vy) > 0.0 else move_toward(velocity.y, 0.0, SPEED)
		syncPos = global_position
		move_and_slide()

@rpc("any_peer","call_local")
func fire():
	var b := projectile.instantiate()
	b.global_position = muzzle.global_position
	b.global_rotation = weapon.global_rotation
	get_tree().root.add_child(b)
