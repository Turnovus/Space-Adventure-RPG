extends HBoxContainer


const TEXT_ICON_MAJOR = 30
const TEXT_ICON_MINOR = 25

@export_subgroup("components")
@export var tool_readout : RichTextLabel

var inventory : Inventory


func _ready():
	var player : Agent = await ReferenceSingleton.get_player()
	inventory = player.inventory
	inventory.contents_modified.connect(_on_player_inventory_modified)
	_on_player_inventory_modified()


func _update_tools():
	tool_readout.clear()
	tool_readout.push_list(1, RichTextLabel.LIST_DOTS, true)
	
	var tools : Dictionary = inventory.get_best_tools()
	for tool : ToolTemplate in tools.keys():
		tool_readout.add_image(tool.icon, TEXT_ICON_MAJOR, TEXT_ICON_MAJOR)
		tool_readout.push_bold()
		tool_readout.append_text(tool.label.capitalize())
		tool_readout.pop()
		tool_readout.append_text(" - ")
		var item : Item = tools[tool]
		tool_readout.add_image(item.icon, TEXT_ICON_MINOR, TEXT_ICON_MINOR)
		tool_readout.append_text("{item} ({effectiveness})".format({
			"item" : item.label.capitalize(),
			"effectiveness" : item.get_tool_effectiveness(tool),
		}))
		tool_readout.append_text("\n")


func _on_player_inventory_modified():
	_update_tools()
