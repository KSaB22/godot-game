extends Node2D

@export var game_seed: int = 1234
@export var level: int = 1

@onready var seedTE: TextEdit = $Seed
@onready var levelTE: TextEdit = $Level
@onready var continue_button: Button = $Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/Level.tscn")
	var next_scene = preload("res://scenes/Level.tscn").instantiate()
	next_scene.game_seed = game_seed
	next_scene.level = level

	get_tree().root.add_child(next_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = next_scene

	

func _on_level_text_changed() -> void:
	if levelTE.text != "":
		level = int(levelTE.text)
	else:
		level = 1

func _on_seed_text_changed() -> void:
	if seedTE.text != "":
		game_seed = int(seedTE.text)
	else:
		game_seed = 1234
