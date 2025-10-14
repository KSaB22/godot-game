extends CharacterBody2D

@export var attack_range: float = 150.0
@export var move_speed: float = 80.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 2.0
@export var max_health: int = 20

@export var projectile_scene: PackedScene

var player_in_same_room: bool = false
var player_ref: Node2D = null
var can_attack: bool = true
var attack_timer: float = 0.0
var enemy_room_id: int = -2
var current_health: int = max_health

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var projectile_spawn: Node2D = $ProjectileSpawn
@onready var level: Node2D = get_tree().get_first_node_in_group("level")

func _ready():
	# Add enemy to enemy group
	add_to_group("enemy")
	
	# Get the enemy's room ID when spawned
	if level and level.has_method("room_id_at_global"):
		enemy_room_id = level.room_id_at_global(global_position)
	
	# Set up animations if they exist
	if animated_sprite.sprite_frames:
		animated_sprite.play("idle")
	
	current_health = max_health

func _physics_process(delta):
	
	# Check if player is in the same room
	update_player_in_same_room()
	
	if not player_in_same_room or player_ref == null:
		# Return to idle behavior
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		velocity = Vector2.ZERO
		return
	
	# Update attack cooldown
	if not can_attack:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true
	
	# Calculate direction to player
	var direction = (player_ref.global_position - global_position).normalized()
	var distance_to_player = global_position.distance_to(player_ref.global_position)
	
	# Attack if player is in range
	if distance_to_player <= attack_range and can_attack:
		attack_player(direction)
	elif distance_to_player > attack_range:
		# Move toward player
		velocity = direction * move_speed
		move_and_slide()
		
		# Update animation
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		
		# Flip sprite based on direction, ignoring vertical-only movement
		if direction.x != 0:
			animated_sprite.flip_h = direction.x < 0
	else:
		# Player in attack range but cooling down
		velocity = Vector2.ZERO
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

func take_damage(damage_amount: int):
	current_health -= damage_amount
	print("Enemy took ", damage_amount, " damage! Health: ", current_health)
	
	if current_health <= 0:
		die()

func die():
	queue_free()

func update_player_in_same_room():
	if not level or not level.has_method("room_id_at_global"):
		return
	
	# Find the nearest player in the same room
	var players = get_tree().get_nodes_in_group("player")
	var closest_player = null
	var min_distance_sq = INF # Use squared distance to avoid sqrt
	
	for player in players:
		var player_room_id = level.room_id_at_global(player.global_position)
		if player_room_id == enemy_room_id and enemy_room_id >= 0:
			var distance_sq = global_position.distance_squared_to(player.global_position)
			if distance_sq < min_distance_sq:
				min_distance_sq = distance_sq
				closest_player = player
	
	if closest_player:
		player_in_same_room = true
		player_ref = closest_player
	else:
		player_in_same_room = false
		player_ref = null

func attack_player(direction: Vector2):
	if not can_attack or player_ref == null:
		return
	
	can_attack = false
	attack_timer = attack_cooldown

	launch_projectile(direction)

func launch_projectile(direction: Vector2):
	if not projectile_spawn:
		return
		
	var projectile = projectile_scene.instantiate()
	projectile.global_position = projectile_spawn.global_position
	projectile.rotation = direction.angle()
	projectile.damage = attack_damage
	projectile.is_player_projectile = false
	get_parent().add_child(projectile)
