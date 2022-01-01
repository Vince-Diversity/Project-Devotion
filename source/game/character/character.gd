extends KinematicBody2D
class_name Character

enum States {ROAMING, BATTLING, TALKING}

export var aspect: Resource
export var lvl := 0
export var battle_order: int
export var party_order: int
var state = States.ROAMING
var party_node: Party
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
onready var accessories = $CharacterVisual/AccessoriesSprite
onready var hair = $CharacterVisual/HairSprite
onready var skin = $CharacterVisual/SkinSprite
onready var body = $CharacterVisual/BodySprite
onready var battle_actions = $BattleActions
onready var mind_node = $MindNode

func _ready():
	init_areas()
	init_actions()
	init_mind()

func _physics_process(_delta):
	match state:
		States.ROAMING:
			roam()
		States.BATTLING:
			pass
		States.TALKING:
			pass

func init_areas():
	following_area.character = self
	interaction_area.character = self

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

func ready_party():
	party_node = get_parent()

func is_leader():
	return party_order == 0

func roam():
	if is_leader():
		input_direction()
		if direction == Vector2.ZERO:
			idle()
		else:
			move(self.direction, self.speed)
	else:
		follow_next_ally()

func follow_next_ally():
	if is_leader():
		print("Error: leader %s trying to follow!" % self)
	next_ally = get_next_ally()
	if outside_following_area:
		var next_direction = next_ally.velocity.normalized()
		if next_direction != Vector2.ZERO:
			move(next_direction, next_ally.speed)
	else:
		idle()

func move(target_direction, target_speed):
		animate_movement(target_direction)
		velocity = target_direction * target_speed
		velocity = move_and_slide(velocity)

func idle():
	animate_idle()

func input_direction():
	pass

func animate_idle():
	for sprite in get_sprites():
		sprite.stop()
		sprite.set_frame(0)

func animate_movement(target_direction):
	var anim_name = parse_move_direction(target_direction)
	for sprite in get_sprites():
		sprite.play(anim_name)

func parse_move_direction(target_direction) -> String:
	snapped_direction = Utils.snap_to_compass(target_direction)
	anim_id = Kw.anim_map[snapped_direction]
	if anim_id == Kw.Anims.RIGHT:
		anim_id = Kw.Anims.LEFT
		flip_sprite()
	else:
		reset_sprite()
	return Kw.anim[anim_id]

func reset_sprite():
	for sprite in get_sprites():
		sprite.set_flip_h(false)

func prepare_roaming():
	state = States.ROAMING

func prepare_battle():
	state = States.BATTLING
	position = Vector2.ZERO
	reset_sprite()

func prepare_talking():
	state = States.TALKING

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

func get_next_ally():
	if is_leader():
		return self
	return get_party_ordered()[party_order - 1]

func get_party_ordered() -> Array:
	var list = party_node.get_children()
	list.invert()
	return list

func _on_FollowingArea_area_exited(area):
	if state == States.ROAMING:
		if area.character.name == get_next_ally().name:
			outside_following_area = true

func _on_FollowingArea_area_entered(area):
	if state == States.ROAMING:
		if area.character.name == get_next_ally().name:
			outside_following_area = false

func _on_InteractionArea_area_entered(_area):
	if state == States.ROAMING:
		pass
