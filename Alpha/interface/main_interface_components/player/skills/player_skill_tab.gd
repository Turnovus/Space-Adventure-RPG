extends HBoxContainer


const GROUP_ICON_SIZE = 30
const SKILL_ICON_SIZE = 22

var skills : SkillTracker
var tree_items : Dictionary = {}
var tree_root : TreeItem

@onready var tree : Tree = $Tree


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	skills = galaxy.player.skills
	skills.skill_altered.connect(_on_skill_altered)
	
	rebuild_tree()


func rebuild_tree():
	tree_items = {}
	tree_root = null
	tree.clear()
	tree_root = tree.create_item()
	
	var skills_by_group : Dictionary = {}
	for skill in skills.skills:
		if not skills_by_group.has(skill.group):
			skills_by_group[skill.group] = []
		skills_by_group[skill.group].append(skill)
	
	for group in skills_by_group.keys():
		var group_item = add_skill_group(group)
		for skill in skills_by_group[group]:
			add_skill(group_item, skill)


func add_skill_group(group : SkillGroup) -> TreeItem:
	var item = tree.create_item(tree_root)
	item.set_icon(0, group.icon)
	item.set_text(0, group.label)
	item.set_icon_max_width(0, GROUP_ICON_SIZE)
	return item


func add_skill(group_item : TreeItem, skill : Skill):
	var item = tree.create_item(group_item)
	item.set_icon(0, skill.icon)
	item.set_text(0, skill.label)
	item.set_icon_max_width(0, SKILL_ICON_SIZE)
	tree_items[skill] = item
	update_skill(skill)


func update_skill(skill : Skill):
	var item : TreeItem = tree_items[skill]
	item.set_text(1, "Level " + str(snapped(skills.get_exact_level(skill), 0.001)))
	
	var level_progress = skills.get_experience(skill)
	var level_requirement = skills.get_experience_needed(skill)
	var progress = "{percent}% ({progress}/{needed})".format({
		"percent" : snapped(100 * level_progress / level_requirement, 0.01),
		"progress" : snapped(level_progress, 0.1),
		"needed" : level_requirement,
	})
	item.set_text(2, progress)


func _on_skill_altered(skill : Skill, _level_before : float, _level_after : float):
	update_skill(skill)
