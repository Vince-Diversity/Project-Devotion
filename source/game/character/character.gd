extends Node2D
class_name Character

export var aspect: Resource
export var lvl := 0
export var battle_order: int
var mind: Mind
var aspect_skills
onready var mind_scene = preload("res://source/game/character/mind.tscn")
onready var accessories = $CharacterVisual/AccessoriesSprite
onready var hair = $CharacterVisual/HairSprite
onready var skin = $CharacterVisual/SkinSprite
onready var body = $CharacterVisual/BodySprite
onready var battle_actions = $BattleActions
onready var mind_node = $MindNode

func _ready():
	init_actions()
	init_mind()

func init_actions():
	for action in battle_actions.get_children():
		action.user = self
	aspect_skills = load(aspect.skill_path).instance()
	battle_actions.add_child(aspect_skills)
	for skill in aspect_skills.get_children():
		skill.user = self

func init_mind():
	if mind_node.get_child_count() > 1:
		print("Error, %s Mind is not set up correctly!" % name)
		return
	elif mind_node.get_child_count() == 0:
		mind = mind_scene.instance()
		mind_node.add_child(mind)
	mind = mind_node.get_children()[0]

func flip_sprite():
	for sprite in get_sprites():
		sprite.set_flip_h(true)

func get_sprites():
	return [body, skin, hair, accessories]

func get_actions():
	var all = battle_actions.get_children()
	var aspect_type
	for i in all.size():
		if all[i] is AspectSkills:
			aspect_type = all.pop_at(i)
			break
	var actions = []
	for action in all:
		actions.append(action)
	for skill in aspect_type.get_children():
		actions.append(skill)
	return actions
