extends KinematicBody2D
class_name Character

enum States {ROAMING, INTERACTING, BATTLING}
export var aspect: Resource
export var lvl := 0
export var battle_order: int
export var party_order: int
export(String, "default", "down", "left", "up", "right") var facing_direction = "default"
var state = States.ROAMING
var party: Party
var next_ally
var outside_following_area: bool
var outside_interaction_area: bool
var mind: Mind
var aspect_skills
var direction := Vector2.ZERO
var snapped_direction := Vector2.ZERO
var speed := 100
var velocity := Vector2()
var anim_id: int
onready var mind_scene = preload("res://source/game/character/mind.tscn")
onready var collision_box = $CollisionBox
onready var following_area = $FollowingArea
onready var interaction_area = $InteractionArea
onready var character_visual = $CharacterVisual
onready var accessories = $CharacterVisual/AccessoriesSprite
onready var hair = $CharacterVisual/HairSprite
onready var skin = $CharacterVisual/SkinSprite
onready var body = $CharacterVisual/BodySprite
onready var battle_actions = $BattleActions
onready var mind_node = $MindNode

func _ready():
	ready_areas()
	ready_actions()
	ready_mind()
	turn_to_default()

func ready_areas():
	following_area.character = self
	interaction_area.character = self

func ready_actions():
	for action in battle_actions.get_children():
		action.user = self
	aspect_skills = load(aspect.skill_path).instance()
	battle_actions.add_child(aspect_skills)
	for skill in aspect_skills.get_children():
		skill.user = self

func ready_mind():
	if mind_node.get_child_count() > 1:
		print("Error, %s Mind is not set up correctly!" % name)
		return
	elif mind_node.get_child_count() == 0:
		mind = mind_scene.instance()
		mind_node.add_child(mind)
	mind = mind_node.get_children()[0]

func input_direction():
	pass

func is_leader():
	return party_order == 0

func roam():
	if is_leader():
		input_direction()
		if should_idle():
			idle()
		else:
			move(self.direction)
	else:
		follow_next_ally()

func should_idle():
	if direction == Vector2.ZERO: return true
	if state == States.INTERACTING: return true
	return false

func follow_next_ally():
	if is_leader():
		print("Error: leader %s trying to follow!" % self)
	next_ally = get_next_ally()
	if outside_following_area:
		var next_direction = (next_ally.global_position - global_position)
		next_direction = next_direction.normalized()
		move(next_direction)
	else:
		idle()

func move(target_direction):
		velocity = target_direction * speed
		velocity = move_and_slide(velocity)
		animate_movement(target_direction)

func idle():
	character_visual.animate_idle()

func animate_movement(target_direction):
	var anim_name = parse_move_direction(target_direction)
	character_visual.animate_movement(anim_name)

func turn_face(asker):
	var asker_direction = asker.global_position - global_position
	var anim_name = parse_move_direction(asker_direction)
	character_visual.set_animation(anim_name)

func turn_to_default():
	character_visual.set_animation(facing_direction)

func parse_move_direction(target_direction) -> String:
	snapped_direction = Utils.snap_to_compass(target_direction)
	anim_id = Kw.anim_map[snapped_direction]
	if anim_id == Kw.Anims.RIGHT:
		anim_id = Kw.Anims.LEFT
		character_visual.flip_sprite()
	else:
		character_visual.reset_sprite()
	return Kw.anim[anim_id]

func prepare_battle():
	position = Vector2.ZERO
	character_visual.reset_sprite()

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

func get_next_ally():
	if is_leader():
		return self
	return party.get_party_ordered()[party_order - 1]

func _on_FollowingArea_area_exited(area):
	if state == States.ROAMING:
		if area.character.name == get_next_ally().name:
			outside_following_area = true

func _on_FollowingArea_area_entered(area):
	if state == States.ROAMING:
		if area.character.name == get_next_ally().name:
			outside_following_area = false
