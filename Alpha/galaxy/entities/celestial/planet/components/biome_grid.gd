class_name BiomeGrid
extends Node


const NOISE_SCALE : float = 3
const TEMPERATURE_RANDOMNESS : float = 0.15

@export var generator : BiomeGenerator

var biomes : Array
var foraging : Array
var size : int
var texture : ImageTexture = null
var spawnable_tiles : Array

var noise_elevation : BiomeNoise
var noise_moisture : BiomeNoise
var noise_temperature : BiomeNoise


func _ready():
	size = get_parent().get_size().x
	generate()


func generate():
	biomes = Array()
	foraging = Array()
	spawnable_tiles = Array()
	var biome_row = Array()
	var forage_row = Array()
	
	noise_moisture = BiomeNoise.new(randi(), size, NOISE_SCALE)
	noise_elevation = BiomeNoise.new(randi(), size, NOISE_SCALE)
	noise_temperature = BiomeNoise.new(randi(), size, NOISE_SCALE)
	
	for i in range(size):
		var temperature = abs(float(size) / 2 - i) / size
		temperature = 1 - (4 * temperature)
		temperature *= 1 - TEMPERATURE_RANDOMNESS
		
		biome_row = []
		forage_row = []
		for j in range(size):
			var random_temperature = noise_temperature.get_noise_at(i, j)
			random_temperature *= TEMPERATURE_RANDOMNESS
			random_temperature += temperature
			var moisture = noise_moisture.get_noise_at(i, j)
			var elevation = noise_elevation.get_noise_at(i, j)
			
			var biome = generator.get_biome(moisture, random_temperature, elevation)
			biome_row.append(biome)
			if biome.allow_spawn:
				spawnable_tiles.append([j,i])
			
			var forage_here : Array[ForageTile] = []
			for forage : BiomeForage in  biome.forage_groups:
				forage_here.append(ForageTile.new(forage))
			forage_row.append(forage_here)
		
		biomes.append(biome_row.duplicate())
		foraging.append(forage_row.duplicate())


func get_texture() -> Texture2D:
	if texture == null:
		regenerate_texture()
	
	return texture


func regenerate_texture():
	#texture = ImageTexture.new()
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	generate_image(image)
	texture = ImageTexture.create_from_image(image)


func generate_image(image : Image):
	for y in range(size):
		var row = biomes[y]
		for x in range(size):
			if row[x] != null:
				image.set_pixel(x, y, row[x].map_color)


func get_spawnable_location() -> Vector2:
	if spawnable_tiles.is_empty():
		return Vector2.ZERO
	
	var random = spawnable_tiles.pick_random()
	var vector = Vector2(random[0], random[1]) / size
	vector *= 2
	vector -= Vector2.ONE
	return vector


func get_biome_at(position : Vector2) -> Biome:
	position += Vector2.ONE
	position /= 2
	position *= size
	return biomes[int(position.y)][int(position.x)]


func get_forage_at(position : Vector2) -> ForageTile:
	position += Vector2.ONE
	position /= 2
	position *= size
	return foraging[int(position.y)][int(position.x)]


func update():
	for row : Array in foraging:
		for tiles : Array in row:
			for tile : ForageTile in tiles:
				tile.update(1) #TODO: Winter


class BiomeNoise:
	const NOISE_OFFSET : float = 0
	const NOISE_FACTOR : float = 1.05
	
	var noise_seed : int = 0 :
		set(new_seed):
			noise_seed = new_seed
			noise.seed = new_seed
	
	var size : float
	var scale : float
	var noise : FastNoiseLite = FastNoiseLite.new()
	
	
	func _init(new_seed : int, new_size : float, new_scale : float):
		noise_seed = new_seed
		size = new_size
		scale = new_scale
	
	
	func get_noise_at(x, y) -> float:
		var y_shift = size + fmod(y + size*0.5, size)
		
		var a = noise.get_noise_2d(x * scale, y * scale)
		var b = noise.get_noise_2d(x * scale, y_shift * scale)
		
		var y_dist = abs (y - size*0.5) / (0.5*size)
		a *= 1 - y_dist
		b *= y_dist
		
		var n = a + b
		n *= NOISE_FACTOR
		n += NOISE_OFFSET
		n = clampf(n, -1, 1)
		return n


class ForageTile:
	var forage_group : ForageGroup
	var max_richness : float
	var richness : float
	
	
	func _init(from : BiomeForage):
		forage_group = from.forage_group
		max_richness = randf_range(forage_group.min_natural_richness, forage_group.max_natural_richness)
		max_richness *= from.richness_factor
		richness = max_richness
	
	
	func update(replenish_factor : float):
		var replenish : float = max_richness / forage_group.replenish_turns
		replenish *= replenish_factor
		richness += replenish
		richness = minf(max_richness, richness)
	
	
	func do_deplete():
		richness = maxf(0, richness - forage_group.depletion_per_forage)
