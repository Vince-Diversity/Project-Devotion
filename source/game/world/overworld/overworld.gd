extends GameWorld
class_name Overworld

onready var menu = $Menu
onready var allies = $Characters/Party
onready var npcs = $Characters/NPCs

func _ready():
	ready_party()

func _physics_process(_delta):
	var leader = allies.get_leader()
	if leader:
		match leader.state:
			leader.States.ROAMING:
				if Input.is_action_just_pressed("ui_accept"):
					interact(allies)
				for ally in get_party_ordered(allies):
					ally.roam()
			leader.States.INTERACTING:
				for ally in get_party_ordered(allies):
					ally.idle()

func ready_party():
	for ally in party_arr:
		allies.add_child(ally)
	for node in npcs.get_children():
		if node is Party:
			node.assign_members()

func interact(party):
	var asker = party.get_leader()
	var asker_area = asker.interaction_area
	for area in asker_area.get_overlapping_areas():
		if area is InteractionArea:
			var responder = area.character
			if responder is NPC:
				interact_with_npc(party, asker, responder)
				break

func interact_with_npc(party: Party, asker: Character, npc: NPC):
	party.set_state(asker.States.INTERACTING)
	asker.turn_face(npc)
	npc.turn_face(asker)
	var d = Dialogic.start(npc.interaction_dialog)
	add_child(d)
	var keep_talk = true
	var switch_to_battle = false
	while keep_talk:
		var response = yield(d, "dialogic_signal")
		match response:
			"battle":
				keep_talk = false
				switch_to_battle = true
			"done":
				keep_talk = false
	yield(get_tree(), "idle_frame")
	npc.turn_to_default()
	party.set_state(asker.States.ROAMING)
	if switch_to_battle:
		npc.confirm_battle()

func get_party_ordered(party_node) -> Array:
	var list = party_node.get_children()
	list.invert()
	return list
