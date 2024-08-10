extends PanelContainer


const TEXT_ICON_SIZE = 25

@export var physical_icon : Texture2D
@export var mental_icon : Texture2D

@onready var readout : RichTextLabel = $VBoxContainer/RichTextLabel


func _ready():
	var player : Agent = await ReferenceSingleton.get_player()
	player.actions.activities_changed.connect(_on_player_activities_changed)


func _on_player_activities_changed():
	var player : Agent = await ReferenceSingleton.get_player()
	var actions : ActionTracker = player.actions
	readout.clear()
	
	if actions.get_num_physical_activities() <= 0 or actions.get_num_mental_activities() <= 0:
		hide()
		return
	
	show()
	var categories : Array = actions.physical_activities_this_turn.keys()
	for mental_category : String in actions.mental_activities_this_turn.keys():
		if not categories.has(mental_category):
			categories.append(mental_category)
	
	if categories.is_empty():
		hide()
		return
	
	readout.push_list(1, RichTextLabel.LIST_DOTS, true)
	for category : String in categories:
		_append_activity_line(category, actions)
	readout.pop()


func _append_activity_line(category : String, actions : ActionTracker):
	readout.append_text(category.capitalize())
	readout.append_text(": ")
	
	var physical_activities = actions.get_num_physical_activities()
	var mental_activities = actions.get_num_mental_activities()
	
	readout.add_image(physical_icon, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
	readout.append_text(str(physical_activities))
	
	readout.add_image(mental_icon, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
	readout.append_text(str(mental_activities))
	
	readout.append_text("\n")
