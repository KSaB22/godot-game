extends Area2D

@export var damage = 20
@export var attack_cooldown = 0.2
@export var texture: Texture2D # Reverted to a single Texture2D

func _ready():
	# Simply assign the texture to the sprite
	if texture:
		$Sprite2D.texture = texture

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_weapon_in_range(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.clear_weapon_in_range(self)

func picked_up():
	queue_free()
