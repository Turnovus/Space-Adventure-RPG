extends HBoxContainer


@export var default_group_icon : Texture2D

@onready var knowledge_group_list = $KnowledgeGroupList
@onready var knowledge_list = $KnowledgeList

@onready var selection_icon = $PanelContainer/SelectionIcon
@onready var selection_label = $PanelContainer/SelectionLabel
@onready var selection_description = $PanelContainer/PanelContainer/ScrollContainer/SelectionDescription

var player_knowledge : KnowledgeTracker
var selected_knowledge_group : int = 0
var selected_knowledge : int = 0

var selected_group_icon : Texture2D


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	
	knowledge_group_list.item_selected.connect(_on_group_selected)
	knowledge_list.item_selected.connect(_on_knowledge_selected)
	
	player_knowledge = galaxy.player.knowledge
	for group in player_knowledge.knowledge_groups:
		var icon = default_group_icon if group.icon == null else group.icon
		knowledge_group_list.add_item(group.label, icon)
	
	knowledge_group_list.select(0)
	knowledge_group_list.item_selected.emit(0)


func update_selected_knowledge():
	var group : KnowledgeGroup = player_knowledge.knowledge_groups[selected_knowledge_group]
	var knowledge : Knowledge = group.knowledge[selected_knowledge]
	
	selection_icon.texture = selected_group_icon if knowledge.icon == null else knowledge.icon
	selection_label.text = knowledge.label
	selection_description.text = knowledge.description


func _on_group_selected(index : int):
	selected_knowledge_group = index
	selected_group_icon = player_knowledge.knowledge_groups[index].icon
	if selected_group_icon == null:
		selected_group_icon = default_group_icon
	
	knowledge_list.clear()
	for knowledge : Knowledge in player_knowledge.knowledge_groups[index].knowledge:
		var icon = selected_group_icon if knowledge.icon == null else knowledge.icon
		knowledge_list.add_item(knowledge.label, icon)
	
	knowledge_list.select(0)
	knowledge_list.item_selected.emit(0)


func _on_knowledge_selected(index : int):
	selected_knowledge = index
	update_selected_knowledge()


func _on_turn_post(_turn : int):
	update_selected_knowledge()
