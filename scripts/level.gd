extends Node2D

enum Room_types {RECTANGLE, CIRCLE}
enum Area_War {WIN, LOSE, COMBINE}

var game_seed: int = 1234
var level: int = 1
var room_dic = {}
var room_tiles = {}
@onready var level_tile_map: TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_level():
	seed(game_seed)
	var amount_of_rooms = 100 #randi_range(level*2 , 4 * level)
	var level_size = Vector2i(180, 150)
	level_tile_map.clear()
	print(amount_of_rooms)
	for i in range(amount_of_rooms):
		generate_room(i, level_size)
	generate_walls()
	connect_rooms()

func generate_room(i: int, level_size: Vector2i):
	room_dic[i] = {
		"type" = Room_types.RECTANGLE if randf() < 0.8 else Room_types.CIRCLE,
		"tiles" = [],
		"war_with" = {},
		"center" = Vector2i(0,0)
	}
	var origin_x = randi_range(-level_size[0] / 2, level_size[0] / 2)
	var origin_y = randi_range(-level_size[1] / 2, level_size[1] / 2)
	room_dic[i]["center"] = Vector2i(origin_x, origin_y)

	if room_dic[i]["type"] == Room_types.RECTANGLE:
		var length = randi_range(5, 20)
		var height = randi_range(5, 20)
		for x in range(length):
			for y in range(height):
				var thiscoords = Vector2i(x + origin_x, y + origin_y)
				if not room_tiles.has(thiscoords):
					add_floor_tile(thiscoords, i)
				else:
					i = handle_war(thiscoords,i)

	elif room_dic[i]["type"] == Room_types.CIRCLE:
		var radius = randi_range(3, 10)
		var center = Vector2i(origin_x, origin_y)
		for x in range(center.x - radius, center.x + radius + 1):
			for y in range(center.y - radius, center.y + radius + 1):
				var dist_sq = (x - center.x) * (x - center.x) + (y - center.y) * (y - center.y)
				if dist_sq < radius * radius:
					var thiscoords = Vector2i(x, y)
					if not room_tiles.has(thiscoords):
						add_floor_tile(thiscoords,i)
					else:
						i = handle_war(thiscoords,i)

	# Add walls around the room
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]
	for tile in room_tiles.keys():
		for dir in directions:
			var neighbor = tile + dir
			if not room_tiles.has(neighbor):
				level_tile_map.set_cell(0, neighbor, 0, Vector2i(9, 6))

func add_floor_tile(this_coords, i):
	room_dic[i]["tiles"].append(this_coords)
	room_tiles[this_coords] = i
	var tileset_picker = Vector2i(randi_range(6, 9), randi_range(0, 2))
	level_tile_map.set_cell(0, this_coords, 0, tileset_picker)
	
func handle_war(this_coords, i):
	var j = room_tiles[this_coords]
	if i == j:
		return i
	if not room_dic[i]["war_with"].has(j):
		var war_result = randi_range(1,3)
		room_dic[i]["war_with"][j] = Area_War.WIN if war_result == 1 else Area_War.LOSE if war_result == 2 else Area_War.COMBINE
		room_dic[j]["war_with"][i] = Area_War.LOSE if war_result == 1 else Area_War.WIN if war_result == 2 else Area_War.COMBINE
		if war_result == 1:
			print("Room ",i, " vs Room ",j," → WIN")
		elif war_result == 2:
			print("Room ",i, " vs Room ",j," → LOSE")
		else:
			print("Room ",i, " vs Room ",j," → COMBINE")
		
	if room_dic[i]["war_with"][j] == Area_War.LOSE:
		return i
	if room_dic[i]["war_with"][j] == Area_War.WIN:
		add_floor_tile(this_coords, i)
		return i
	if room_dic[i]["war_with"][j] == Area_War.COMBINE:
		var low_id = i if i < j else j
		var high_id = j if i < j else i
		var high_tiles = room_dic[high_id]["tiles"]
		var low_tiles = room_dic[low_id]["tiles"]
		# Move all tiles to the low_id room
		for tile in high_tiles:
			if not tile in low_tiles:
				low_tiles.append(tile)
				room_tiles[tile] = low_id  # Update tile ownership

		# Optionally clear the merged room if you don't need it anymore
		room_dic.erase(high_id)
		return low_id

func generate_walls():
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]

	for tile in room_tiles.keys():
		for dir in directions:
			var neighbor = tile + dir

			# Neighbor is outside all rooms — add a wall
			if not room_tiles.has(neighbor):
				level_tile_map.set_cell(0, neighbor, 0, Vector2i(9, 6))
				continue

			var my_room = room_tiles[tile]
			var their_room = room_tiles[neighbor]

			if my_room == their_room:
				continue  # Skip if same room

			# Validate data before accessing war result
			if not room_dic.has(my_room) or not room_dic.has(their_room):
				continue

			if not room_dic[my_room].has("war_with") or not room_dic[my_room]["war_with"].has(their_room):
				continue

			var result = room_dic[my_room]["war_with"][their_room]
			var loser = -1

			match result:
				Area_War.WIN:
					loser = their_room
				Area_War.LOSE:
					loser = my_room
				Area_War.COMBINE:
					continue  # No wall between merged rooms

			# Place wall on the losing room's tile
			if room_tiles[neighbor] == loser:
				level_tile_map.set_cell(0, neighbor, 0, Vector2i(9, 6))

func connect_rooms():
	var connected = []
	var unconnected = room_dic.keys()
	if unconnected.size() == 0:
		return
	room_dic[-1]= {
		"tiles" = []
	}
	connected.append(unconnected.pop_front())

	while unconnected.size() > 0:
		var closest_dist = INF
		var from_id = -1
		var to_id = -1

		for cid in connected:
			var c_center = room_dic[cid]["center"]
			for uid in unconnected:
				var u_center = room_dic[uid]["center"]
				var dist = c_center.distance_to(u_center)
				if dist < closest_dist:
					closest_dist = dist
					from_id = cid
					to_id = uid

		if from_id != -1 and to_id != -1:
			create_corridor(room_dic[from_id]["center"], room_dic[to_id]["center"], from_id)
			connected.append(to_id)
			unconnected.erase(to_id)
			
func create_corridor(from: Vector2i, to: Vector2i, room_id: int):
	var current = from

	# Horizontal movement
	while current.x != to.x:
		var step = sign(to.x - current.x)
		current.x += step
		dig_corridor_tile(current, room_id, "horizontal")

	# Vertical movement
	while current.y != to.y:
		var step = sign(to.y - current.y)
		current.y += step
		dig_corridor_tile(current, room_id, "vertical")

func dig_corridor_tile(pos: Vector2i, room_id: int, direction: String):
	var floor_offsets := []

	# Widen perpendicular to direction
	if direction == "horizontal":
		floor_offsets = [Vector2i(0, 0), Vector2i(0, 1)]  # vertical widening
	elif direction == "vertical":
		floor_offsets = [Vector2i(0, 0), Vector2i(1, 0)]  # horizontal widening

	# Place floor tiles
	for offset in floor_offsets:
		var tile = pos + offset
		if not room_tiles.has(tile):
			add_floor_tile(tile, -1)

	# Compute proper wall offsets
	var wall_offsets := []

	if direction == "horizontal":
		# We are stepping horizontally (corridor is 2 tiles tall)
		wall_offsets = [ Vector2i(0, -1), Vector2i(0,  1)]
	elif direction == "vertical":
		# We are stepping vertically (corridor is 2 tiles wide)
		wall_offsets = [Vector2i(-1,  0),Vector2i(1,  0)]
	wall_offsets = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]
	# Place walls if tile isn't already floor
	for offset in floor_offsets:
		var tile = pos + offset
		for dir in wall_offsets:
			var neighbor = tile + dir
			if not room_tiles.has(neighbor):
				level_tile_map.set_cell(0, neighbor, 0, Vector2i(9, 6))
