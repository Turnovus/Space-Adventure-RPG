class_name TabController
extends Node


enum TabCountDisplay {
	NEVER,
	NOT_ZERO,
	ALWAYS,
}


signal tab_count_changed(tab : Node)


@export var tab_icon : Texture2D
@export var show_count : TabCountDisplay = TabCountDisplay.NEVER

var count : int = 0:
	set(new_count):
		count = new_count
		tab_count_changed.emit(get_parent())
