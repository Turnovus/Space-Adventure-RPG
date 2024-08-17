class_name MainNode
extends Control


@export_subgroup("components")
@export var popup_blackout : Control
@export var popup_container : Control


func _ready():
	get_tree().set_auto_accept_quit(false)


func _notification(what: int):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# NOTE: Freeing popups before the SceneTree quits allows us to use the tree_exited signal
		# from popups without needing to know whether the node freed itself, or was freed by the
		# quit function.
		popup_blackout.queue_free()
		get_tree().quit()


func get_galaxy() -> Galaxy:
	# Broken up in case we decide to do something interesting with save/load
	# states or something later.
	var galaxy = get_node("Galaxy")
	
	if galaxy == null:
		print("Tried to read null galaxy.")
	
	return galaxy


func push_popup(node : Control):
	popup_blackout.show()
	popup_container.add_child(node)
	node.tree_exited.connect(_on_popup_free)
	if node.has_method("notify_popup"):
		node.call("notify_popup")


func _on_popup_free():
	if popup_container.get_child_count() <= 0:
		popup_blackout.hide()
