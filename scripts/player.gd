# scripts/player.gd
extends CharacterBody2D

# Movement variables
@export var speed: float = 225.0

# Shooting variables
@export var projectile_speed: float = 500.0
@export var projectile_damage: int = 10
@export var attack_cooldown: float = 0.5
@export var projectile: PackedScene

# Weapon stats
var current_weapon_damage: int = projectile_damage
var current_attack_cooldown: float = attack_cooldown

# Multiplayer sync variables
@export var syncedHP: float = 100.0
@export var syncPos: Vector2 = Vector2.ZERO
@export var syncRot := 0.0

var can_shoot: bool = true
var attack_timer: float = 0.0
var weapon_in_range: Area2D = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_rotation: Node2D = $WeaponRotation
@onready var weapon_sprite: Sprite2D = $WeaponRotation/Weapon
@onready var muzzle: Node2D = $WeaponRotation/ProjectileSpawn
@onready var camera: Camera2D = $Camera2D

func _ready():
	add_to_group("player")
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if camera and is_multiplayer_authority():
		camera.make_current()

	if animated_sprite.sprite_frames:
		animated_sprite.play("idle")

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		weapon_rotation.look_at(get_global_mouse_position())
		syncRot = weapon_rotation.rotation

		if Input.is_action_just_pressed("Fire") and can_shoot:
			fire.rpc()
			can_shoot = false
			attack_timer = current_attack_cooldown

		if Input.is_action_just_pressed("PickUp") and weapon_in_range:
			# Call the RPC to equip the weapon across the network
			equip_weapon_rpc.rpc(weapon_in_range.get_path())

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
		if animated_sprite.sprite_frames and animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		if input_vector.x != 0:
			animated_sprite.flip_h = input_vector.x < 0
	else:
		velocity = Vector2.ZERO
		if animated_sprite.sprite_frames and animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	move_and_slide()

@rpc("any_peer","call_local")
func fire():
	var b := projectile.instantiate()
	b.global_position = muzzle.global_position
	b.global_rotation = weapon_rotation.global_rotation
	b.damage = current_weapon_damage
	b.is_player_projectile = true
	get_tree().root.add_child(b)

func take_damage(damage_amount: int):
	syncedHP -= damage_amount
	if syncedHP <= 0:
		die()
	print("Player took ", damage_amount, " damage!")

func die():
	print("Player died!")
	queue_free()

func set_weapon_in_range(weapon: Area2D):
	weapon_in_range = weapon

func clear_weapon_in_range(weapon: Area2D):
	if weapon_in_range == weapon:
		weapon_in_range = null

# This RPC initiates the pickup process on all clients
@rpc("any_peer", "call_local")
func equip_weapon_rpc(weapon_path: NodePath):
	var weapon = get_node_or_null(weapon_path)
	if not weapon: return

	# Only the player with authority gets the data and calls the next RPC
	if is_multiplayer_authority():
		var buffer = weapon.texture_buffer
		set_equipped_weapon.rpc(buffer, weapon.damage, weapon.attack_cooldown)

	# The weapon is removed from the game world for everyone
	weapon.picked_up()

# This RPC syncs the player's weapon appearance and stats to all clients
@rpc("any_peer", "call_local")
func set_equipped_weapon(buffer: PackedByteArray, damage: int, cooldown: float):
	# Update stats for all clients
	current_weapon_damage = damage
	current_attack_cooldown = cooldown

	# Create and apply the texture on each client's machine
	var image = Image.new()
	if image.load_png_from_buffer(buffer) == OK:
		var texture = ImageTexture.create_from_image(image)
		weapon_sprite.texture = texture
	else:
		push_error("Failed to create equipped weapon texture from network data.")
