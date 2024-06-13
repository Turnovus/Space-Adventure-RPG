class_name Identity
extends Node


enum Gender {
	NONE,
	MALE,
	FEMALE,
}

enum GenderChoice {
	NONE,
	ANY,
	ALWAYS_MALE,
	ALWAYS_FEMALE,
}

const pronouns = {
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

var title : String = "nameless"
var gender : Gender = Gender.NONE


func _ready():
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
