extends Control


signal galaxy_begin

@onready var parallax : ParallaxBackground = $ParallaxBackground
@onready var parallax_sprite : Sprite2D = $ParallaxBackground/ParallaxLayer/Sprite2D


func _process(delta):
	var tex_scale = parallax_sprite.texture.get_size() * 10
	
	parallax.scroll_offset += Vector2(-10, -5) * delta


func get_galaxy() -> Galaxy:
	# Broken up in case we decide to do something interesting with save/load
	# states or something later.
	var galaxy = get_node("Galaxy")
	
	if galaxy == null:
		print("Tried to read null galaxy.")
	
	return galaxy
