extends Node2D

@export var game_seed: int = 1234
@export var level: int = 1

@onready var seedTE: TextEdit = $Seed
@onready var host_btn: Button = $HostBtn
@onready var start_btn: Button = $StartBtn

@export var Address = '192.168.31.255'
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	$ServerBrowser.joinGame.connect(joinByIP)
	pass # Replace with function body.
	



func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	GameManager.seed = game_seed
	print("Waiting For Players!")

@rpc("any_peer")
func SendPlayerInformation(id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] ={
			"id" : id,
			"score": 0
		}

func _on_seed_text_changed() -> void:
	if seedTE.text != "":
		game_seed = int(seedTE.text)
	else:
		game_seed = 1234


func _on_host_button_pressed() -> void:
	seedTE.editable = false
	hostGame()
	var host_id = multiplayer.get_unique_id()
	SendPlayerInformation(host_id)
	$ServerBrowser.setUpBroadcast(str(host_id) + "'s server" , game_seed)
	host_btn.disabled = true
	start_btn.disabled = false
	pass # Replace with function body.
	

func joinByIP(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	host_btn.disabled = true
	
func peer_connected(id):
	print("Player Connected: " + str(id))
	
func peer_disconnected(id):
	print("Player Disconnected: " + str(id))

func connected_to_server():
	var table := $ServerBrowser/Panel/VBoxContainer
	for row in table.get_children():
		var btn := row.get_node_or_null("JoinBtn")
		if btn and btn is Button:
			btn.disabled = true
	SendPlayerInformation.rpc_id(1,multiplayer.get_unique_id())
	print("connected To Server!")

# called only from clients
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer", "call_local")
func startGame():
	var scene_res = load("res://scenes/Level.tscn")
	var scene = scene_res.instantiate()

	# Now you can safely set properties defined in Level.gd
	scene.game_seed = GameManager.seed
	scene.max_players = GameManager.Players.size()

	get_tree().root.add_child(scene)
	self.hide()


func _on_start_btn_pressed() -> void:
	startGame.rpc()
	pass # Replace with function body.
