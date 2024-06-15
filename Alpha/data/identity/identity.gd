class_name Identity
extends Node


enum Gender {
	NONE,
	MALE,
	FEMALE,
	INDETERMINATE,
}

enum GenderChoice {
	NONE,
	ANY,
	ALWAYS_MALE,
	ALWAYS_FEMALE,
}

const PRONOUNS = {
	"self" : {
		"singular" : {
			"preferred_name" : "I",
			"pronoun" : "I",
			"possessive" : "my",
			"objective" : "me",
			"reflective" : "myself",
		},
		"plural" : {
			"preferred_name" : "we",
			"pronoun" : "we",
			"possessive" : "our",
			"objective" : "us",
			"reflective" : "ourselves",
		},
	},
	"other" : {
		"singular" : {
			"preferred_name" : "you",
			"pronoun" : "you",
			"possessive" : "your",
			"objective" : "you",
			"reflective" : "yourself",
		},
		"plural" : {
			"preferred_name" : "you",
			"pronoun" : "you",
			"possessive" : "your",
			"objective" : "you",
			"reflective" : "yourselves",
		},
	},
	"none" : {
		"singular" : {
			"pronoun" : "it",
			"possessive" : "its",
			"objective" : "it",
			"reflective" : "itself",
		},
		"plural" : {
			"pronoun" : "they",
			"possessive" : "their",
			"objective" : "them",
			"reflective" : "themselves",
		},
	},
	"male" : {
		"singular" : {
			"pronoun" : "he",
			"possessive" : "his",
			"objective" : "him",
			"reflective" : "himself",
		},
		"plural" : {
			"pronoun" : "they",
			"possessive" : "their",
			"objective" : "them",
			"reflective" : "themselves",
		},
	},
	"female" : {
		"singular" : {
			"pronoun" : "she",
			"possessive" : "her",
			"objective" : "her",
			"reflective" : "herself",
		},
		"plural" : {
			"pronoun" : "they",
			"possessive" : "their",
			"objective" : "them",
			"reflective" : "themselves",
		},
	},
}

@export var random_gender : GenderChoice = GenderChoice.NONE
@export var namer : Namer
@export_subgroup("Codex")
@export var default_codex_icon : Texture2D
@export var unknown_title : String = "unknown"

var title : String = "nameless"
var gender : Gender = Gender.INDETERMINATE

var initialize_on_ready = false


func _init(autoinitialize : bool = true):
	initialize_on_ready = autoinitialize


func _ready():
	if not initialize_on_ready:
		return
	
	if namer != null:
		title = namer.resolve_name(get_parent())
	randomize_gender()


func randomize_gender():
	match random_gender:
		GenderChoice.NONE:
			gender = Gender.NONE
		GenderChoice.ANY:
			gender = Gender.MALE if randf() > 0.5 else Gender.FEMALE
		GenderChoice.ALWAYS_MALE:
			gender = Gender.MALE
		GenderChoice.ALWAYS_FEMALE:
			gender = Gender.FEMALE


static func get_title(identity : Identity, known : bool = true) -> String:
	if identity == null:
		return "nothing"
	return identity.title if known else identity.unknown_title


static func get_gender(identity : Identity, known : bool = true) -> Gender:
	if identity == null:
		return Gender.NONE
	if known:
		return identity.gender
	# Genderless entities can always be identified as such.
	return Gender.NONE if identity.gender == Gender.NONE else Gender.INDETERMINATE
