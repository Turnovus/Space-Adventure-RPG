extends Node
class_name KnowledgeTracker


@export var knowledge_groups : Array[KnowledgeGroup] = []

var learned_knowledge : Dictionary


func _ready():
	learned_knowledge = {}
	for group : KnowledgeGroup in knowledge_groups:
		for knowledge : Knowledge in group.knowledge:
			learned_knowledge[knowledge.key] = 0.0


func get_learning(knowledge : Knowledge) -> float:
	return learned_knowledge[knowledge.key]


func has_learned(knowledge : Knowledge) -> bool:
	return get_learning(knowledge) >= knowledge.base_cost


func can_learn(knowledge : Knowledge) -> bool:
	if has_learned(knowledge):
		return false
	for prerequisite in knowledge.prerequisites:
		if not has_learned(prerequisite):
			return false
	return true


func learn_knowledge(knowledge : Knowledge, amount : float):
	var knowledge_post = learned_knowledge[knowledge.key] + amount
	learned_knowledge[knowledge.key] = minf(knowledge.base_cost, knowledge_post)


func do_random_learning(mental_points : int, progress : float):
	var possible = []
	for i in knowledge_groups:
		for j in i.knowledge:
			if can_learn(j):
				possible.append(j)
	
	for i in range(0, mental_points):
		if possible.is_empty():
			return
		
		var random = possible.pick_random()
		learn_knowledge(random, progress)
		if not can_learn(random):
			possible.erase(random)
