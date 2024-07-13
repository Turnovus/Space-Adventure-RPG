class_name BiomeGeneratorChoice
extends BiomeGenerator


@export var biomes : Array[Biome] = []


func get_biome(_moisture : float, _temperature : float, _elevation  : float) -> Biome:
	return biomes.pick_random()
