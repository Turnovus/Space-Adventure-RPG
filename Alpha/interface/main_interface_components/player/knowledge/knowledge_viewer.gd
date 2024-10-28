extends HBoxContainer


@export var default_group_icon : Texture2D

var player_knowledge : KnowledgeTracker
var selected_knowledge_group : int = 0
var selected_knowledge : int = 0

var selected_group_icon : Texture2D

@onready var knowledge_group_list = $KnowledgeGroupList
@onready var knowledge_list = $KnowledgeList

@onready var selection_icon = $PanelContainer/SelectionIcon
@onready var selection_label = $PanelContainer/SelectionLabel
@onready var selection_progress = $PanelContainer/SelectionProgress
@onready var selection_description = $PanelContainer/PanelContainer/ScrollContainer/SelectionDescription


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
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
	
	selection_description.clear()
	selection_description.push_color(get_knowledge_color(knowledge, true))
	selection_description.append_text(get_completion_text(knowledge))
	
	selection_description.push_color(GameColorUtil.COLOR_NORMAL)
	selection_description.append_text("\n\n")
	selection_description.append_text(knowledge.description)
	
	var color = get_knowledge_color(knowledge)
	selection_label.set("theme_override_colors/font_color", color)
	selection_icon.modulate = color
	
	selection_progress.text = "{progress}/{cost}".format({
		"progress" : snapped(player_knowledge.get_learning(knowledge), 0.01),
		"cost" : knowledge.base_cost,
	})


func _on_group_selected(index : int):
	selected_knowledge_group = index
	selected_group_icon = player_knowledge.knowledge_groups[index].icon
	if selected_group_icon == null:
		selected_group_icon = default_group_icon
	
	knowledge_list.clear()
	for knowledge : Knowledge in player_knowledge.knowledge_groups[index].knowledge:
		var icon = selected_group_icon if knowledge.icon == null else knowledge.icon
		var item = knowledge_list.add_item(knowledge.label, icon)
		
		var color = get_knowledge_color(knowledge)
		knowledge_list.set_item_custom_fg_color(item, color)
		knowledge_list.set_item_icon_modulate(item, color)
	
	knowledge_list.select(0)
	knowledge_list.item_selected.emit(0)


func get_knowledge_color(knowledge : Knowledge, use_alt=false) -> Color:
	if player_knowledge.has_learned(knowledge):
		return GameColorUtil.COLOR_GOOD_READABLE if use_alt else GameColorUtil.COLOR_NORMAL
	elif player_knowledge.can_learn(knowledge):
		return GameColorUtil.COLOR_POSSIBILITY_READABLE
	else:
		return GameColorUtil.COLOR_BAD_READABLE


func get_completion_text(knowledge : Knowledge) -> String:
	if player_knowledge.has_learned(knowledge):
		return "You have mastered this knowledge."
	elif player_knowledge.can_learn(knowledge):
		return "You are still learning this knowledge."
	else:
		var text = "You can not yet learn this knowledge."
		var all_missing = []
		
		for prerequisite in knowledge.prerequisites:
			if not player_knowledge.has_learned(prerequisite):
				all_missing.append(prerequisite)
		
		if len(all_missing) > 0:
			text += "\nMissing prerequisites:"
			for missing in all_missing:
				text += "\n - " + missing.label
		
		return text


func _on_knowledge_selected(index : int):
	selected_knowledge = index
	update_selected_knowledge()


func _on_turn_post(_turn : int):
	var group : KnowledgeGroup = player_knowledge.knowledge_groups[selected_knowledge_group]
	for i in range(0, knowledge_list.item_count):
		var knowledge : Knowledge = group.knowledge[i]
		var color = get_knowledge_color(knowledge)
		knowledge_list.set_item_custom_fg_color(i, color)
		knowledge_list.set_item_icon_modulate(i, color)
	
	update_selected_knowledge()
