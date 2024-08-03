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
@export var clear_count_on_open : bool = false

var container : CustomTabContainer

var count : int = 0:
	set(new_count):
		if clear_count_on_open and container.get_current_tab_control() == get_parent():
			count = 0
		else:
			count = new_count
		tab_count_changed.emit(get_parent())


func notify_selected():
	if clear_count_on_open:
		count = 0
