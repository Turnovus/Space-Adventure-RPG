class_name BiomeGrid
extends Node


@export var base_biome : Biome
@export var random_biomes : Array[Biome]

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
	for i in range(size):
		row.append(base_biome)
	for i in range(size):
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
	#image.lock()
	
	for y in range(size):
		var row = biomes[y]
		for x in range(size):
			image.set_pixel(x, y, row[x].map_color)
	
	#image.unlock()
