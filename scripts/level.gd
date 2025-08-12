extends Node2D

enum Room_types {RECTANGLE, CIRCLE}
enum Area_War {WIN, LOSE, COMBINE}

const LAYER := 0
const WALL_ATLAS := Vector2i(9, 6)

var game_seed: int = 1234
var level: int = 1
var room_dic := {}
var room_tiles := {}
@onready var level_tile_map: TileMap = $TileMap

func _ready() -> void:
	generate_level()

func _process(_delta: float) -> void:
	pass

func generate_level() -> void:
	seed(game_seed)
	var amount_of_rooms: int = 100 # randi_range(level*2 , 4 * level)
	var level_size := Vector2i(180, 150)

	level_tile_map.clear()
	room_dic.clear()
	room_tiles.clear()

	print(amount_of_rooms)
	for i in range(amount_of_rooms):
		generate_room(i, level_size)
	generate_walls()
	connect_rooms()

# --- helpers -------------------------------------------------------

func place_wall_at(p: Vector2i) -> void:
	level_tile_map.set_cell(LAYER, p, 0, WALL_ATLAS)
	# If this position was owned by a room, remove it from both maps
	if room_tiles.has(p):
		var rid: int = room_tiles[p]
		room_tiles.erase(p)
		if room_dic.has(rid) and room_dic[rid].has("tiles"):
			room_dic[rid]["tiles"].erase(p)

func add_floor_tile(this_coords: Vector2i, i: int) -> void:
	# Ownership
	room_tiles[this_coords] = i
	if room_dic.has(i):
		if not room_dic[i].has("tiles"):
			room_dic[i]["tiles"] = []
		if this_coords not in room_dic[i]["tiles"]:
			room_dic[i]["tiles"].append(this_coords)

	# Visual (random floor)
	var tileset_picker := Vector2i(randi_range(6, 9), randi_range(0, 2))
	level_tile_map.set_cell(LAYER, this_coords, 0, tileset_picker)

func handle_war(this_coords: Vector2i, i: int) -> int:
	# this_coords is guaranteed in room_tiles before calling handle_war
	var j: int = room_tiles[this_coords]
	if i == j:
		return i

	# Initialize relation if missing
	if not room_dic[i]["war_with"].has(j):
		var war_result: int = randi_range(1, 3)
		room_dic[i]["war_with"][j] = Area_War.WIN if war_result == 1 else Area_War.LOSE if war_result == 2 else Area_War.COMBINE
		if room_dic.has(j):
			if not room_dic[j].has("war_with"):
				room_dic[j]["war_with"] = {}
			room_dic[j]["war_with"][i] = Area_War.LOSE if war_result == 1 else Area_War.WIN if war_result == 2 else Area_War.COMBINE

		if war_result == 1:
			print("Room ", i, " vs Room ", j, " → WIN")
		elif war_result == 2:
			print("Room ", i, " vs Room ", j, " → LOSE")
		else:
			print("Room ", i, " vs Room ", j, " → COMBINE")

	var res: int = room_dic[i]["war_with"][j]
	match res:
		Area_War.LOSE:
			return i
		Area_War.WIN:
			add_floor_tile(this_coords, i)
			return i
		Area_War.COMBINE:
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
			return low_id

	return i # fallback

# --- generation ----------------------------------------------------

func generate_room(i: int, level_size: Vector2i) -> void:
	room_dic[i] = {
		"type": Room_types.RECTANGLE if randf() < 0.8 else Room_types.CIRCLE,
		"tiles": [],
		"war_with": {},
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
					i = handle_war(thiscoords, i)

	elif room_dic[i]["type"] == Room_types.CIRCLE:
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
						i = handle_war(thiscoords, i)

	# Add walls *around this room only*
	var directions: Array[Vector2i] = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]
	for tile in room_dic[i]["tiles"]:
		for dir in directions:
			var neighbor: Vector2i = tile + dir
			if not room_tiles.has(neighbor):
				place_wall_at(neighbor)

func generate_walls() -> void:
	var directions: Array[Vector2i] = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

	# Iterate over a snapshot of keys to avoid mutation issues while placing walls
	var keys_snapshot: Array = room_tiles.keys()
	for tile in keys_snapshot:
		# tile must exist, but re-check because earlier writes may have changed things
		if not room_tiles.has(tile):
			continue

		for dir in directions:
			var neighbor: Vector2i = tile + dir

			# Neighbor is outside all rooms — add a wall
			if not room_tiles.has(neighbor):
				place_wall_at(neighbor)
				continue

			var my_room: int = room_tiles[tile]
			var their_room: int = room_tiles[neighbor]

			if my_room == their_room:
				continue  # same room, no border wall

			# Validate we have war data
			if not room_dic.has(my_room) or not room_dic.has(their_room):
				continue
			if not room_dic[my_room].has("war_with"):
				continue
			if not room_dic[my_room]["war_with"].has(their_room):
				continue

			var result: int = room_dic[my_room]["war_with"][their_room]
			var loser := -1

			match result:
				Area_War.WIN:
					loser = their_room
				Area_War.LOSE:
					loser = my_room
				Area_War.COMBINE:
					continue  # merged; no border wall

			# Place wall on the losing room's tile — but only if neighbor still mapped
			if room_tiles.has(neighbor) and room_tiles[neighbor] == loser:
				place_wall_at(neighbor)

# --- corridors -----------------------------------------------------

func connect_rooms() -> void:
	var connected: Array = []
	var unconnected: Array = room_dic.keys()
	if unconnected.is_empty():
		return

	# Bucket for corridors
	room_dic[-1] = {"tiles": [], "center": Vector2i.ZERO, "war_with": {}}

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

	# Horizontal movement
	while current.x != to.x:
		var step: int = sign(to.x - current.x)
		current.x += step
		dig_corridor_tile(current, room_id, "horizontal")

	# Vertical movement
	while current.y != to.y:
		var step: int = sign(to.y - current.y)
		current.y += step
		dig_corridor_tile(current, room_id, "vertical")

func dig_corridor_tile(pos: Vector2i, _room_id: int, direction: String) -> void:
	var floor_offsets: Array[Vector2i] = []

	# 2-wide corridor, widen perpendicular to direction
	if direction == "horizontal":
		floor_offsets = [Vector2i(0, 0), Vector2i(0, 1)]  # vertical widening
	elif direction == "vertical":
		floor_offsets = [Vector2i(0, 0), Vector2i(1, 0)]  # horizontal widening

	# Place floor tiles (use corridor bucket -1)
	for offset in floor_offsets:
		var tile: Vector2i = pos + offset
		if not room_tiles.has(tile):
			add_floor_tile(tile, -1)

	# 8-neighborhood walls around corridor strip
	var wall_offsets: Array[Vector2i] = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

	for offset in floor_offsets:
		var tile2: Vector2i = pos + offset
		for dir in wall_offsets:
			var neighbor: Vector2i = tile2 + dir
			if not room_tiles.has(neighbor):
				place_wall_at(neighbor)
