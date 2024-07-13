class_name BiomeGeneratorProperty
extends BiomeGenerator


@export var groups : Array[BiomeGeneratorGroup] = []
@export var type : PropertyType


enum PropertyType {
	MOISTURE = 0,
	TEMPERATURE = 1,
	ELEVATION = 2,
}


func get_biome(moisture : float, temperature : float, elevation  : float) -> Biome:
	var value
	match type:
		PropertyType.MOISTURE:
			value = moisture
		PropertyType.TEMPERATURE:
			value = temperature
		PropertyType.ELEVATION:
			value = elevation
	
	for group : BiomeGeneratorGroup in groups:
		if value <= group.max_value:
			return group.generator.get_biome(moisture, temperature, elevation)
	return null
