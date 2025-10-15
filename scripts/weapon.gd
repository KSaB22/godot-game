# scripts/weapon.gd
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# This will store the raw image data for the player to retrieve
var texture_buffer: PackedByteArray

# These are your weapon's specific stats
var damage: int = 15
var attack_cooldown: float = 0.4

# The _ready function that was scaling the sprite has been removed.

# This is called by the level to set the texture when the weapon is first spawned
@rpc("any_peer", "call_local")
func set_texture_rpc(buffer: PackedByteArray):
	texture_buffer = buffer
	
	var image = Image.new()
	if image.load_png_from_buffer(buffer) == OK:
		var texture = ImageTexture.create_from_image(image)
		
		if is_instance_valid(sprite_2d):
			sprite_2d.texture = texture
		else:
			push_error("Weapon sprite node is missing or named incorrectly!")
	else:
		push_error("Failed to load weapon texture from network data.")

# --- Functions to detect the player ---

func _on_body_entered(body):
	if body.has_method("set_weapon_in_range"):
		body.set_weapon_in_range(self)
		print("Player entered weapon range")

func _on_body_exited(body):
	if body.has_method("clear_weapon_in_range"):
		body.clear_weapon_in_range(self)
		print("Player exited weapon range")

func picked_up():
	if is_instance_valid(collision_shape):
		collision_shape.set_deferred("disabled", true)
	queue_free()
