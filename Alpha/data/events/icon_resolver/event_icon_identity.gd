class_name EventIconResolverIdentity
extends EventIconResolver


func resolve_icon(target) -> Texture2D:
	var entity : Entity = target as Entity
	if entity == null:
		return null
	
	var identity = entity.get_identity()
	return identity.default_codex_icon if identity != null else null
