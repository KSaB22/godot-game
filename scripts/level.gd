extends Node2D

enum Room_types { RECTANGLE, CIRCLE }

const LAYER := 0
const WALL_ATLAS := Vector2i(9, 6)

var game_seed: int = 1234
var max_players: int = 2
var room_dic := {}
var room_tiles := {}

# Track current/last room for the main player
var current_room_id: int = -2
var last_non_corridor_room_id: int = -2

@onready var level_tile_map: TileMap = $TileMap

@export var PlayerScene: PackedScene

@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var playerSpawns: Node2D = $Players


func _ready() -> void:
	add_to_group("level")
	generate_level()
	handle_spawns()
	


func _process(_delta: float) -> void:
	return

func handle_spawns() -> void:
	var spawns: Array[Dictionary] = get_leaf_spawns(max_players)
	var index := 0
	
	for peer_id in GameManager.Players:
		if index >= spawns.size():
			break
			
		var spawn_info = spawns[index]
		
		print("This is character  " + str(peer_id))
		PlayerScene = preload("res://scenes/player.tscn")
		var p := PlayerScene.instantiate()
		p.name = str(peer_id)
		p.set_multiplayer_authority(peer_id)
		$Players.add_child(p, true)
		
		p.global_position = tile_to_global(spawn_info["pos"])
		p.syncPos = tile_to_global(spawn_info["pos"])
		index += 1

func generate_level() -> void:
	seed(game_seed)
	var amount_of_rooms: int = 100
	var level_size := Vector2i(180, 150)

	level_tile_map.clear()
	room_dic.clear()
	room_tiles.clear()

	for i in range(amount_of_rooms):
		generate_room(i, level_size)

	connect_rooms()
	_calculate_all_room_depths()
	generate_walls()


# --- helpers -------------------------------------------------------

func tile_to_global(tile: Vector2i) -> Vector2:
	return level_tile_map.to_global(level_tile_map.map_to_local(tile))


func global_to_tile(global_pos: Vector2) -> Vector2i:
	return level_tile_map.local_to_map(level_tile_map.to_local(global_pos))


func room_id_at_tile(tile: Vector2i) -> int:
	return int(room_tiles[tile]) if  room_tiles.has(tile) else -2


func room_id_at_global(global_pos: Vector2) -> int:
	return room_id_at_tile(global_to_tile(global_pos))


func get_current_room_id(currentPlayer, use_last_known_inside: bool = false) -> int:
	var rid: int = room_id_at_global(currentPlayer.global_position)

	if rid != current_room_id:
		current_room_id = rid
		if rid >= 0:
			last_non_corridor_room_id = rid
	
	if use_last_known_inside and rid == -1 and last_non_corridor_room_id >= 0:
		return last_non_corridor_room_id

	return rid


func place_wall_at(p: Vector2i) -> void:
	if room_tiles.has(p):
		return
	level_tile_map.set_cell(LAYER, p, 0, WALL_ATLAS)


func add_floor_tile(this_coords: Vector2i, i: int) -> void:
	room_tiles[this_coords] = i
	if room_dic.has(i):
		if not room_dic[i].has("tiles"):
			room_dic[i]["tiles"] = []
		if this_coords not in room_dic[i]["tiles"]:
			room_dic[i]["tiles"].append(this_coords)

	var tileset_picker := Vector2i(randi_range(6, 9), randi_range(0, 2))
	level_tile_map.set_cell(LAYER, this_coords, 0, tileset_picker)


func handle_combine(this_coords: Vector2i, i: int) -> int:
	var j: int = room_tiles[this_coords]
	if i == j:
		return i

	var low_id: int = i if i < j else j
	var high_id: int = j if i < j else i

	if room_dic.has(high_id) and room_dic.has(low_id):
		var high_room = room_dic[high_id]
		var low_room = room_dic[low_id]
		
		for tile in high_room.get("tiles", []):
			if tile not in low_room["tiles"]:
				low_room["tiles"].append(tile)
				room_tiles[tile] = low_id
		
		for child_id in high_room.get("children", []):
			if child_id not in low_room["children"]:
				low_room["children"].append(child_id)
				if room_dic.has(child_id):
					room_dic[child_id]["parent"] = low_id
					
		room_dic.erase(high_id)

	room_tiles[this_coords] = low_id
	return low_id


# --- generation ----------------------------------------------------

func generate_room(i: int, level_size: Vector2i) -> void:
	room_dic[i] = {
		"type": Room_types.RECTANGLE if randf() < 0.8 else Room_types.CIRCLE,
		"tiles": [],
		"center": Vector2i.ZERO,
		"parent": -1,
		"children": [],
		"depth": 0 
	}

	var origin_x: int = randi_range(-level_size.x / 2, level_size.x / 2)
	var origin_y: int = randi_range(-level_size.y / 2, level_size.y / 2)
	room_dic[i]["center"] = Vector2i(origin_x, origin_y)

	if room_dic[i]["type"] == Room_types.RECTANGLE:
		var length: int = randi_range(5, 20)
		var height: int = randi_range(5, 20)
		for x in range(length):
			for y in range(height):
				var thiscoords: Vector2i = Vector2i(x + origin_x, y + origin_y)
				if not room_tiles.has(thiscoords):
					add_floor_tile(thiscoords, i)
				else:
					i = handle_combine(thiscoords, i)

	else: # CIRCLE
		var radius: int = randi_range(3, 10)
		var center: Vector2i = Vector2i(origin_x, origin_y)
		for x in range(center.x - radius, center.x + radius + 1):
			for y in range(center.y - radius, center.y + radius + 1):
				var dist_sq: int = (x - center.x) * (x - center.x) + (y - center.y) * (y - center.y)
				if dist_sq < radius * radius:
					var thiscoords: Vector2i = Vector2i(x, y)
					if not room_tiles.has(thiscoords):
						add_floor_tile(thiscoords, i)
					else:
						i = handle_combine(thiscoords, i)


func generate_walls() -> void:
	var directions: Array[Vector2i] = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                   Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

	var keys_snapshot: Array = room_tiles.keys()
	for tile in keys_snapshot:
		if not room_tiles.has(tile):
			continue
		for dir in directions:
			var neighbor: Vector2i = tile + dir
			if not room_tiles.has(neighbor):
				place_wall_at(neighbor)


# --- corridors -----------------------------------------------------

func connect_rooms() -> void:
	var connected: Array = []
	var unconnected: Array = room_dic.keys()
	if unconnected.is_empty():
		return

	room_dic[-1] = {"tiles": [], "center": Vector2i.ZERO}
	connected.append(unconnected.pop_front())

	while not unconnected.is_empty():
		var closest_dist := INF
		var from_id := -1
		var to_id := -1

		for cid in connected:
			if not room_dic.has(cid):
				continue
			var c_center: Vector2i = room_dic[cid]["center"]
			for uid in unconnected:
				if not room_dic.has(uid):
					continue
				var u_center: Vector2i = room_dic[uid]["center"]
				var dist: float = float(c_center.distance_to(u_center))
				if dist < closest_dist:
					closest_dist = dist
					from_id = cid
					to_id = uid

		if from_id != -1 and to_id != -1:
			create_corridor(room_dic[from_id]["center"], room_dic[to_id]["center"])
			
			room_dic[to_id]["parent"] = from_id
			room_dic[from_id]["children"].append(to_id)
			
			connected.append(to_id)
			unconnected.erase(to_id)


func create_corridor(from: Vector2i, to: Vector2i) -> void:
	var current := from

	while current.x != to.x:
		var step: int = sign(to.x - current.x)
		current.x += step
		dig_corridor_tile(current, "horizontal")

	while current.y != to.y:
		var step: int = sign(to.y - current.y)
		current.y += step
		dig_corridor_tile(current, "vertical")


func dig_corridor_tile(pos: Vector2i, direction: String) -> void:
	var floor_offsets: Array[Vector2i] = []

	if direction == "horizontal":
		floor_offsets = [Vector2i(0, 0), Vector2i(0, 1)]
	else:
		floor_offsets = [Vector2i(0, 0), Vector2i(1, 0)]

	for offset in floor_offsets:
		var tile: Vector2i = pos + offset
		if not room_tiles.has(tile):
			add_floor_tile(tile, -1)
			

# --- tree-based room detection & spawns ---------------------------------

func _calculate_all_room_depths() -> void:
	var root_id = -1
	for room_id in room_dic.keys():
		if room_id >= 0 and room_dic[room_id]["parent"] == -1:
			root_id = room_id
			break
	
	if root_id != -1:
		_calculate_depth_recursive(root_id, 0)

func _calculate_depth_recursive(room_id: int, current_depth: int) -> void:
	if not room_dic.has(room_id):
		return
	
	room_dic[room_id]["depth"] = current_depth
	for child_id in room_dic[room_id]["children"]:
		_calculate_depth_recursive(child_id, current_depth + 1)


func _dirs8() -> Array[Vector2i]:
	return [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                   Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]


func get_leaf_rooms() -> Array[int]:
	var leaves: Array[int] = []
	for room_id in room_dic.keys():
		if room_id < 0:
			continue
		
		if room_dic[room_id].has("children") and room_dic[room_id]["children"].is_empty():
			leaves.append(room_id)
	
	if leaves.is_empty():
		for room_id in room_dic.keys():
			if room_id >= 0:
				leaves.append(room_id)
				
	return leaves


func pick_spawn_in_room(room_id: int) -> Vector2i:
	if not room_dic.has(room_id):
		return Vector2i.ZERO
		
	var candidates: Array[Vector2i] = []
	var tiles: Array = room_dic[room_id].get("tiles", [])
	
	for t in tiles:
		var tile: Vector2i = t
		var touches_outside := false
		for d in _dirs8():
			var n := tile + d
			if not room_tiles.has(n):
				touches_outside = true
				break
		if touches_outside:
			candidates.append(tile)
			
	if candidates.is_empty():
		return room_dic[room_id].get("center", Vector2i.ZERO)
		
	return candidates[randi() % candidates.size()]


func get_leaf_spawns(count: int) -> Array[Dictionary]:
	var spawns: Array[Dictionary] = []
	var leaves: Array = get_leaf_rooms()
	
	leaves.sort_custom(
		func(a, b):
			return room_dic[a]["depth"] > room_dic[b]["depth"]
	)
	
	for room_id in leaves:
		if spawns.size() >= count:
			break
		var spawn_pos = pick_spawn_in_room(room_id)
		spawns.append({"pos": spawn_pos, "room_id": room_id})

	if spawns.size() < count and not leaves.is_empty():
		var root_id = -1
		for id in room_dic:
			if id >= 0 and room_dic[id]["parent"] == -1:
				root_id = id
				break
		
		if root_id != -1:
			var root_already_in_spawns = false
			for spawn_info in spawns:
				if spawn_info["room_id"] == root_id:
					root_already_in_spawns = true
					break
			if not root_already_in_spawns:
				var spawn_pos = pick_spawn_in_room(root_id)
				spawns.append({"pos": spawn_pos, "room_id": root_id})

	return spawns


func died(id):
	var players = $Players.get_children()
	for player in players:
		if id == player.name:
			player.die()
			return
	return
