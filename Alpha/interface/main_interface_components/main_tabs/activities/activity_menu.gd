extends VBoxContainer


@onready var physical_text : Label = $InfoBar/PhysicalText
@onready var mental_text : Label = $InfoBar/MentalText


func _ready():
	var player : Agent = await ReferenceSingleton.get_player()
	player.actions.activities_changed.connect(_on_activities_changed)
	_on_activities_changed()


func _on_activities_changed():
	var player : Agent = await ReferenceSingleton.get_player()
	var actions : ActionTracker = player.actions
	
	physical_text.text = "{used}/{max}".format({
		"used" : actions.get_num_physical_activities(),
		"max" : actions.get_max_physical_activities(),
	})
	mental_text.text = "{used}/{max}".format({
		"used" : actions.get_num_mental_activities(),
		"max" : actions.get_max_mental_activities(),
	})
