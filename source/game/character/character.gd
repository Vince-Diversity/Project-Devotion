extends KinematicBody2D
class_name Character

export var aspect: Resource
export var lvl := 0
export var battle_order: int
export var party_order: int
export(String, "default", "down", "left", "up", "right") var default_anim_name = "default"
var state = Kw.OwStates.ROAMING
var party: Party
var next_ally
var outside_following_area: bool
var outside_interaction_area: bool
var mind: Mind
var aspect_skills
var inputted_direction := Vector2.ZERO
var snapped_direction := Vector2.ZERO
var speed := 100
var velocity := Vector2()
var anim_id: int
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
onready var name_label = $NameLabel

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
		print("Error, %s's Mind is not set up correctly!" % name)
	if mind_node.get_child_count() == 1:
		mind = mind_node.get_children()[0]
		mind.user = self

func ready_name_label():
	name_label.text = "%s[%s]" % [name, aspect.symbol]

func set_lvl(new_lvl):
	lvl = new_lvl

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
			move(self.inputted_direction)
	else:
		follow_next_ally()

func should_idle():
	if state == Kw.OwStates.INTERACTING: return true
	if inputted_direction == Vector2.ZERO: return true
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
	var true_anim_name = parse_move_direction(target_direction)
	character_visual.animate_movement(true_anim_name)

func turn_face(asker):
	var asker_direction = asker.global_position - global_position
	var true_anim_name = parse_move_direction(asker_direction)
	character_visual.set_animation(true_anim_name)

func turn_to_default():
	character_visual.set_animation(default_anim_name)

func turn_to_direction(given_direction):
	var true_anim_name = parse_move_direction(given_direction)
	character_visual.set_animation(true_anim_name)

func parse_move_direction(target_direction) -> String:
	snapped_direction = Utils.snap_to_compass(target_direction)
	var true_anim_id = Kw.anim_map[snapped_direction]
	return Kw.anim[true_anim_id]

func prepare_battle():
	position = Vector2.ZERO
	character_visual.reset_sprite()

func get_actions() -> Array:
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

func get_true_anim_id() -> int:
	if character_visual.is_flipped():
		return Kw.Anims.RIGHT
	else:
		return anim_id

func _on_FollowingArea_area_exited(area):
	if state != Kw.OwStates.BATTLING:
		if area.character.name == get_next_ally().name:
			outside_following_area = true

func _on_FollowingArea_area_entered(area):
	if state != Kw.OwStates.BATTLING:
		if area.character.name == get_next_ally().name:
			outside_following_area = false
