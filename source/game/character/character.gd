extends Node2D
class_name Character

export var individual: Resource
var mind: Mind
onready var body = $CharacterVisual/BodySprite
onready var hair = $CharacterVisual/HairSprite
onready var accessories = $CharacterVisual/AccessoriesSprite
onready var battle_actions = $BattleActions
onready var mind_node = $MindNode

func _ready():
	init_character()

func init_character():
	body.frames = individual.body
	hair.frames = individual.hair
	accessories.frames = individual.accessories
	if mind_node.get_child_count() != 1:
		print("Error, character Mind is not set up correctly!")
		return
	mind = mind_node.get_children()[0]

func get_sprites():
	return [body, hair, accessories]
