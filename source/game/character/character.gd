extends Node2D
class_name Character

export var individual: Resource
onready var body = $CharacterVisual/BodySprite
onready var hair = $CharacterVisual/HairSprite
onready var accessories = $CharacterVisual/AccessoriesSprite

func _ready():
	init_character()

func init_character():
	body.frames = individual.body
	hair.frames = individual.hair
	accessories.frames = individual.accessories

func get_sprites():
	return [body, hair, accessories]
