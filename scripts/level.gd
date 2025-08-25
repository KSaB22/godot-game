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
	generate_level()
	var spawns: Array[Vector2i] = get_edge_spawns(max_players)
	var index := 0
	for peer_id in GameManager.Players:
		print("This is character  " + str(peer_id))
		var p := PlayerScene.instantiate()
		p.name = str(peer_id)
		p.set_multiplayer_authority(peer_id)  
		add_child(p, true)
		p.global_position = Vector2(0,0) #tile_to_global(spawns[index])
		p.syncPos = Vector2(0,0) #tile_to_global(spawns[index])
		index += 1

func _process(_delta: float) -> void:
	#var exact_room: int = get_current_room_id(false)
	#var stable_room: int = get_current_room_id(true)
	#print("exact:", exact_room, " stable:", stable_room)
	return

func generate_level() -> void:
	seed(game_seed)
	var amount_of_rooms: int = 100 # randi_range(max_players*2 , 4 * max_players)
	var level_size := Vector2i(180, 150)

	level_tile_map.clear()
	room_dic.clear()
	room_tiles.clear()

	for i in range(amount_of_rooms):
		generate_room(i, level_size)

	connect_rooms()      # dig all corridors after rooms
	generate_walls()     # single global pass to surround all floors

# --- helpers -------------------------------------------------------

func tile_to_global(tile: Vector2i) -> Vector2:
	# World-space center of the cell
	return level_tile_map.to_global(level_tile_map.map_to_local(tile))

func global_to_tile(global_pos: Vector2) -> Vector2i:
	# Convert a world position to tile coords on this TileMap
	return level_tile_map.local_to_map(level_tile_map.to_local(global_pos))

func room_id_at_tile(tile: Vector2i) -> int:
	# >=0 room id, -1 corridor, -2 outside/void
	return int(room_tiles[tile]) if  room_tiles.has(tile) else -2

func room_id_at_global(global_pos: Vector2) -> int:
	return room_id_at_tile(global_to_tile(global_pos))

# Get the main player's current room.
# use_last_known_inside=true will return the last non-corridor room when in a corridor.
func get_current_room_id(currentPlayer, use_last_known_inside: bool = false) -> int:
	var rid: int = room_id_at_global(currentPlayer.global_position)

	# Update tracking vars
	if rid != current_room_id:
		current_room_id = rid
		if rid >= 0:
			last_non_corridor_room_id = rid

	# Optional "sticky" room behavior while in corridor
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

# Always-combine overlap resolver
func handle_combine(this_coords: Vector2i, i: int) -> int:
	var j: int = room_tiles[this_coords]
	if i == j:
		return i

	var low_id: int = i if i < j else j
	var high_id: int = j if i < j else i

	if room_dic.has(high_id) and room_dic.has(low_id):
		var high_tiles: Array = room_dic[high_id]["tiles"]
		var low_tiles: Array = room_dic[low_id]["tiles"]
		for tile in high_tiles:
			if tile not in low_tiles:
				low_tiles.append(tile)
				room_tiles[tile] = low_id
		room_dic.erase(high_id)

	room_tiles[this_coords] = low_id
	return low_id

# --- generation ----------------------------------------------------

func generate_room(i: int, level_size: Vector2i) -> void:
	room_dic[i] = {
		"type": Room_types.RECTANGLE if randf() < 0.8 else Room_types.CIRCLE,
		"tiles": [],
		"center": Vector2i.ZERO
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

	else:
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
		Vector2i(-1,  0),                  Vector2i(1,  0),
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
			create_corridor(room_dic[from_id]["center"], room_dic[to_id]["center"], from_id)
			connected.append(to_id)
			unconnected.erase(to_id)

func create_corridor(from: Vector2i, to: Vector2i, room_id: int) -> void:
	var current := from

	while current.x != to.x:
		var step: int = sign(to.x - current.x)
		current.x += step
		dig_corridor_tile(current, room_id, "horizontal")

	while current.y != to.y:
		var step: int = sign(to.y - current.y)
		current.y += step
		dig_corridor_tile(current, room_id, "vertical")

func dig_corridor_tile(pos: Vector2i, _room_id: int, direction: String) -> void:
	var floor_offsets: Array[Vector2i] = []

	if direction == "horizontal":
		floor_offsets = [Vector2i(0, 0), Vector2i(0, 1)]  # widen vertically
	else:
		floor_offsets = [Vector2i(0, 0), Vector2i(1, 0)]  # widen horizontally

	for offset in floor_offsets:
		var tile: Vector2i = pos + offset
		if not room_tiles.has(tile):
			add_floor_tile(tile, -1)

# --- edge room detection & spawns ---------------------------------

func _dirs8() -> Array[Vector2i]:
	return [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

func is_edge_room(room_id: int) -> bool:
	if room_id == -1:
		return false
	if not room_dic.has(room_id):
		return false
	var tiles: Array = room_dic[room_id].get("tiles", [])
	for t in tiles:
		var tile: Vector2i = t
		for d in _dirs8():
			var n: Vector2i = tile + d
			if not room_tiles.has(n):
				return true
	return false

func get_edge_rooms() -> Array:
	var result: Array = []
	for rid in room_dic.keys():
		if int(rid) == -1:
			continue
		if is_edge_room(int(rid)):
			result.append(int(rid))
	return result

func pick_edge_spawn(room_id: int) -> Vector2i:
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

func get_edge_spawns(max_players: int) -> Array[Vector2i]:
	var spawns: Array[Vector2i] = []
	var edges: Array = get_edge_rooms()
	edges.shuffle()
	for rid in edges:
		if spawns.size() >= max_players:
			break
		spawns.append(pick_edge_spawn(int(rid)))
	return spawns
