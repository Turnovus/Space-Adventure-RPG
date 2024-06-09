extends Node
class_name KnowledgeTracker


@export var knowledge_groups : Array[KnowledgeGroup] = []

var learned_knowledge : Dictionary


func _ready():
	learned_knowledge = {}
	for group : KnowledgeGroup in knowledge_groups:
		for knowledge : Knowledge in group.knowledge:
			learned_knowledge[knowledge.key] = 0.0
