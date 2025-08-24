extends Control

signal found_server
signal server_removed
signal joinGame(ip)
var broadcastTimer : Timer

var RoomInfo = {"name": "name", "playerCount": 0, "Seed": 0}
var broadcaster : PacketPeerUDP
@export var broadcastPort : int = 8912

var listner : PacketPeerUDP
@export var listenPort : int = 8911

@export var broadcastAdr: String = '192.168.31.255'

@export var serverInfo : PackedScene

func _ready() -> void:
	broadcastTimer = $BroadcastTimer
	
	listner = PacketPeerUDP.new()
	var ok = listner.bind(listenPort)
	if ok == OK:
		print("Bound to Listner Port "+ str(listner))
		$"../listnerPortLbl".text = "Bound to Listen port: true"
	else:
		print("faied to bind to Listner port")
		$"../listnerPortLbl".text = "Bound to Listen port: false"
	pass

func setUpBroadcast(name: String,seed: int):
	RoomInfo.name = name
	RoomInfo.Seed = seed
	RoomInfo.playerCount = GameManager.Players.size()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAdr, listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	if ok == OK:
		print("Bound to broadcast Port "+ str(broadcastPort))
	else:
		print("faied to bind to broadcast port")
	$BroadcastTimer.start()

func _process(delta: float) -> void:
	if listner.get_available_packet_count() > 0:
		var serverip = listner.get_packet_ip()
		var serverport = listner.get_packet_port()
		var bytes = listner.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		print("server Ip: " + serverip +" serverPort: "+ str(serverport) + " room info: " + str(roomInfo))
		addServer(roomInfo, serverip)

	pass
#TODO: continue this video - https://www.youtube.com/watch?v=zWjFEVAkz3w

func addServer(roomInfo, serverip) -> void:
	for i in $Panel/VBoxContainer.get_children():
			if i.name == roomInfo.name:
				i.get_node("IPLbl").text = serverip
				i.get_node("PlayerCountLbl").text = str(roomInfo.playerCount)
				return
	var currentInfo = serverInfo.instantiate()
	currentInfo.name = roomInfo.name
	currentInfo.get_node("NameLbl").text = str(roomInfo.name)
	currentInfo.get_node("IPLbl").text = str(serverip)
	currentInfo.get_node("SeedLbl").text = str(roomInfo.Seed)
	currentInfo.get_node("PlayerCountLbl").text = str(roomInfo.playerCount)
	$Panel/VBoxContainer.add_child(currentInfo)
	currentInfo.joinGame.connect(joinByIp)
	
	pass
	
func _on_broadcast_timer_timeout() -> void:
	print("Broadcasting...")
	RoomInfo.playerCount = GameManager.Players.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)
	pass # Replace with function body.
	

func _exit_tree() -> void:
	listner.close()
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

func joinByIp(ip):
	joinGame.emit(ip)
