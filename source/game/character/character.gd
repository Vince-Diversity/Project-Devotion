extends Node2D
class_name Character

export var aspect: Resource
export var lvl := 0
var mind: Mind
onready var mind_scene = preload("res://source/game/character/mind.tscn")
onready var hair = $CharacterVisual/HairSprite
onready var body = $CharacterVisual/BodySprite
onready var accessories = $CharacterVisual/AccessoriesSprite
onready var battle_actions = $BattleActions
onready var mind_node = $MindNode

func _ready():
	init_character()

func init_character():
	if mind_node.get_child_count() > 1:
		print("Error, %s Mind is not set up correctly!" % name)
		return
	elif mind_node.get_child_count() == 0:
		mind = mind_scene.instance()
		mind_node.add_child(mind)
	mind = mind_node.get_children()[0]

func get_sprites():
	return [body, hair, accessories]
