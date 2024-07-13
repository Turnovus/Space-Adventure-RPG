class_name BiomeGrid
extends Node


@export var base_biome : Biome
@export var random_biomes : Array[Biome]

var biomes : Array
var size : int
var texture : ImageTexture


func _ready():
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
	texture = ImageTexture.new()
	var texture_image : Image = Image.create(size, size, false, Image.FORMAT_RG8)
	generate_image(texture_image)
	texture.create_from_image(texture_image)


func generate_image(image : Image):
	image.lock()
	
	for y in range(size):
		var row = biomes[y]
		for x in range(size):
			image.set_pixel(x, y, row[x].mapColor)
	
	image.unlock()
