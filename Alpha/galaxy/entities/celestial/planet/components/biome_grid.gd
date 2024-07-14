class_name BiomeGrid
extends Node


const NOISE_SCALE : float = 3.5
const TEMPERATURE_RANDOMNESS : float = 0.15

@export var generator : BiomeGenerator

var biomes : Array
var size : int
var image : Image
var texture : ImageTexture = null


func _ready():
	size = get_parent().get_size().x
	generate()


func generate():
	biomes = Array()
	var row = Array()
	
	var noise_moisture = FastNoiseLite.new()
	noise_moisture.seed = randi()
	
	var noise_elevation = FastNoiseLite.new()
	noise_elevation.seed = randi()
	
	var noise_temperature = FastNoiseLite.new()
	noise_temperature.seed = randi()
	
	for i in range(size):
		var temperature = abs(float(size) / 2 - i) / size
		temperature = 1 - (4 * temperature)
		temperature *= 1 - TEMPERATURE_RANDOMNESS
		
		row = []
		for j in range(size):
			var random_temperature = noise_temperature.get_noise_2d(i * NOISE_SCALE, j * NOISE_SCALE)
			random_temperature *= TEMPERATURE_RANDOMNESS
			random_temperature += temperature
			var moisture = noise_moisture.get_noise_2d(i * NOISE_SCALE, j * NOISE_SCALE)
			var elevation = noise_elevation.get_noise_2d(i * NOISE_SCALE, j * NOISE_SCALE)
			row.append(generator.get_biome(moisture, random_temperature, elevation))
		biomes.append(row.duplicate())


func get_texture() -> Texture2D:
	if texture == null:
		regenerate_texture()
	
	return texture


func regenerate_texture():
	#texture = ImageTexture.new()
	image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	generate_image(image)
	texture = ImageTexture.create_from_image(image)


func generate_image(image : Image):
	for y in range(size):
		var row = biomes[y]
		for x in range(size):
			if row[x] != null:
				image.set_pixel(x, y, row[x].map_color)
