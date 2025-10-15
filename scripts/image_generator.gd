# image_generator.gd
# This is the autoload singleton script. (REVISED for in-memory loading)
extends Node

signal image_generated(texture: ImageTexture, prompt: String)
signal generation_failed(error_message: String, prompt: String)
signal queue_updated(active_count: int, queued_count: int)

var generation_queue: Array = []
var active_generations: Dictionary = {}
var max_concurrent: int = 4
var generation_counter: int = 0

func _ready():
	max_concurrent = clamp(OS.get_processor_count(), 2, 8)
	print("ImageGenerator ready. Max concurrent generations: %d" % max_concurrent)

func generate(prompt: String, seed: int = -1):
	if prompt.is_empty():
		push_warning("Generate call received an empty prompt.")
		return

	var generation_id = "gen_%d" % generation_counter
	generation_counter += 1
	
	var effective_seed
	if seed > -1:
		effective_seed = seed
	else:
		effective_seed = randi()

	var generation_data = {
		"id": generation_id,
		"prompt": prompt,
		"seed": effective_seed,
		"timestamp": Time.get_time_dict_from_system()
	}

	if len(active_generations) >= max_concurrent:
		generation_queue.append(generation_data)
	else:
		_start_generation(generation_data)
	
	_update_status()

func _start_generation(generation_data: Dictionary):
	var generation_id = generation_data["id"]
	active_generations[generation_id] = generation_data

	var task_id = WorkerThreadPool.add_task(
		_generate_image_task.bind(generation_data),
		false,
		"Generation %s" % generation_id
	)
	
	generation_data["task_id"] = task_id
	_update_status()

func _generate_image_task(generation_data: Dictionary):
	# This function runs on a separate thread.
	var generation_id = generation_data["id"]
	var prompt = generation_data["prompt"]
	var seed = generation_data["seed"]

	var exe_path = ProjectSettings.globalize_path("res://embedded/bin/sd.exe")
	var model_path = ProjectSettings.globalize_path("res://embedded/bin/v1-5-pruned-emaonly.safetensors")
	var lora_dir = ProjectSettings.globalize_path("res://embedded/bin/loras")
	
	# We no longer need an output file path.
	# The "-o -" argument tells many command-line tools to write to standard output.
	var args = PackedStringArray([
		"-m", model_path,
		"--lora-model-dir", lora_dir,
		"-p", "<lora:PixelArtRedmond15V-PixelArt-PIXARFK:1>, pixel art, " + prompt + ", transparent background, one color background",
		"-n", "person, enemy, noise",
		"-H", "512",
		"-W", "512",
		"--steps", "20",
		"--cfg-scale", "7",
		"-s", str(seed),
		"-o", "-" # CHANGED: This now outputs to stdout instead of a file.
	])

	# This array will capture the program's output.
	var output = []
	var exit_code = OS.execute(exe_path, args, output, true)
	
	# If successful, the raw image data will be in the 'output' array.
	if exit_code == 0 and not output.is_empty():
		# The output is a string, so we convert it to a byte buffer.
		var image_buffer: PackedByteArray = output[0].to_utf8_buffer()
		call_deferred("_generation_complete", generation_id, image_buffer, "")
	else:
		var error_msg = "Generation failed (exit code: %d)" % exit_code
		if output.size() > 0:
			error_msg += "\n" + "\n".join(output)
		# Pass an empty buffer on failure.
		call_deferred("_generation_complete", generation_id, PackedByteArray(), error_msg)

func _generation_complete(generation_id: String, image_buffer: PackedByteArray, error: String):
	# This function now receives a byte buffer instead of a file path.
	var generation_data = active_generations.get(generation_id)
	if not generation_data: return

	active_generations.erase(generation_id)

	if not error.is_empty():
		print("Generation %s failed: %s" % [generation_id, error])
		emit_signal("generation_failed", error, generation_data["prompt"])
	elif not image_buffer.is_empty():
		var image = Image.new()
		# Load the image directly from the byte buffer in memory.
		if image.load_png_from_buffer(image_buffer) == OK:
			var processed_image = _remove_background(image)
			var texture = ImageTexture.create_from_image(processed_image)
			emit_signal("image_generated", texture, generation_data["prompt"])
		else:
			var err_msg = "Failed to load image from memory buffer."
			emit_signal("generation_failed", err_msg, generation_data["prompt"])
	else:
		var err_msg = "Generation failed: No image data was received."
		emit_signal("generation_failed", err_msg, generation_data["prompt"])

	if not generation_queue.is_empty():
		var next_generation = generation_queue.pop_front()
		_start_generation(next_generation)
	
	_update_status()

func _remove_background(image: Image) -> Image:
	var new_image = Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	var bg_color = image.get_pixel(0, image.get_height() - 1)
	var tolerance = 0.1
	
	for y in image.get_height():
		for x in image.get_width():
			var pixel_color = image.get_pixel(x, y)
			var is_background = abs(pixel_color.r - bg_color.r) < tolerance and \
							  abs(pixel_color.g - bg_color.g) < tolerance and \
							  abs(pixel_color.b - bg_color.b) < tolerance
			
			if is_background:
				new_image.set_pixel(x, y, Color(0,0,0,0)) # Transparent
			else:
				new_image.set_pixel(x, y, pixel_color)
	return new_image

func _update_status():
	var active = len(active_generations)
	var queued = len(generation_queue)
	emit_signal("queue_updated", active, queued)
