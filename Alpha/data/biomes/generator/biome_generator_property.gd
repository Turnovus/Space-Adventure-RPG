class_name BiomeGeneratorProperty
extends BiomeGenerator


@export var groups : Array[BiomeGeneratorGroup] = []
@export var type : PropertyType


enum PropertyType {
	MOISTURE = 1,
	TEMPERATURE = 2,
	ELEVATION = 3,
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
		if group.max_value <= value:
			return group.generator.get_biome(moisture, temperature, elevation)
	return null
