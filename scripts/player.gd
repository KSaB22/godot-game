extends CharacterBody2D

# Movement variables
@export var speed: float = 225.0

# Shooting variables
@export var projectile_speed: float = 500.0
@export var projectile_damage: int = 10
@export var attack_cooldown: float = 0.5
@export var projectile: PackedScene


# Multiplayer sync variables
@export var syncedHP: float = 100.0
@export var syncPos: Vector2 = Vector2.ZERO
@export var syncRot := 0.0

var can_shoot: bool = true
var attack_timer: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_rotation: Node2D = $WeaponRotation
@onready var muzzle: Node2D = $WeaponRotation/ProjectileSpawn
@onready var camera: Camera2D = $Camera2D


func _ready():
	add_to_group("player")
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if camera and is_multiplayer_authority():
		camera.make_current()
	# Make sure camera is current for this player instance
	
	# Set up animations if they exist
	if animated_sprite.sprite_frames:
		animated_sprite.play("idle")

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		weapon_rotation.look_at(get_global_mouse_position())
		syncRot = weapon_rotation.rotation # radians
		
		if Input.is_action_just_pressed("Fire") and can_shoot:
			fire.rpc(projectile_damage)
			can_shoot = false
			attack_timer = attack_cooldown

		
		# Handle input
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_axis("ui_left", "ui_right")
		input_vector.y = Input.get_axis("ui_up", "ui_down")
		input_vector = input_vector.normalized()
		handle_movement(input_vector)
		if not can_shoot:
			attack_timer -= delta
			if attack_timer <= 0:
				can_shoot = true

func handle_movement(input_vector):
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
		if animated_sprite.sprite_frames:
			if animated_sprite.animation != "walk":
				animated_sprite.play("walk")
		if input_vector.x != 0:
			animated_sprite.flip_h = input_vector.x < 0
	else:
		velocity = Vector2.ZERO
		if animated_sprite.sprite_frames:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")
	
	# Move the character
	move_and_slide()

@rpc("any_peer","call_local")
func fire(damage):	
	var b := projectile.instantiate()
	b.global_position = muzzle.global_position
	b.global_rotation = weapon_rotation.global_rotation
	b.damage = damage
	b.is_player_projectile = true
	get_tree().root.add_child(b)

# Damage handling for when player gets hit by enemy projectiles
func take_damage(damage_amount: int):
	syncedHP -= damage_amount
	if syncedHP <= 0:
		die()
	print("Player took ", damage_amount, " damage!")

func die():
	print("Player died!")
	queue_free()
