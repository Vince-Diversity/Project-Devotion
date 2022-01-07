extends GameWorld
class_name Overworld

const save_timeline = "save-prompt"
const exit_timeline = "main-menu-prompt"
onready var allies = $Characters/Allies
onready var npcs = $Characters/NPCs

func _ready():
	ready_party()

func _physics_process(_delta):
	var leader = allies.get_leader()
	if leader:
		match leader.state:
			Kw.OwStates.ROAMING:
				if Input.is_action_just_pressed("ui_accept"):
					interact(allies)
				if Input.is_action_just_pressed("ui_menu"):
					prompt_menu(save_timeline)
				if Input.is_action_just_pressed("ui_exit"):
					prompt_menu(exit_timeline)
				for ally in get_party_ordered(allies):
					ally.roam()
			Kw.OwStates.INTERACTING:
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
				if !responder.interaction_dialog.empty():
					interact_with_npc(party, asker, responder)
				break

func interact_with_npc(party: Party, asker: Character, npc: NPC):
	party.set_state(Kw.OwStates.INTERACTING)
	asker.turn_face(npc)
	npc.turn_face(asker)
	var d = Dialogic.start(npc.interaction_dialog)
	yield(_dialogic_helper(d, npc), "completed")
	npc.turn_to_default()
	party.set_state(Kw.OwStates.ROAMING)

func dialogic_turn_face(args: Array):
	get_node(args[0]).turn_face(get_node(args[1]))

func prompt_menu(timeline: String):
	allies.set_state(Kw.OwStates.INTERACTING)
	var d = Dialogic.start(timeline)
	yield(_dialogic_helper(d), "completed")
	allies.set_state(Kw.OwStates.ROAMING)

func after_battle_interaction(asker: Character, foe_party: Party):
	var npc = foe_party.get_leader()
	allies.set_state(Kw.OwStates.INTERACTING)
	asker.turn_face(npc)
	npc.turn_face(asker)
	var d = Dialogic.start(npc.after_battle_dialog)
	add_child(d)
	var keep_talk = true
	while keep_talk:
		var response = yield(d, "dialogic_signal")
		match response:
			"done":
				keep_talk = false
	yield(get_tree(), "idle_frame")
	npc.turn_to_default()
	allies.set_state(Kw.OwStates.ROAMING)

func save_game():
	Events.emit_signal("save_game")

func get_party_ordered(party_node) -> Array:
	var list = party_node.get_children()
	list.invert()
	return list

func _dialogic_helper(d, npc=null):
	add_child(d)
	var switch_to_battle = false
	var keep_talk = true
	while keep_talk:
		var response = yield(d, "dialogic_signal")
		match response:
			"battle":
				keep_talk = false
				switch_to_battle = true
			"done":
				keep_talk = false
			"":
				print("Error! Dialogic signal name not specified.")
	yield(get_tree(), "idle_frame")
	if switch_to_battle:
		npc.confirm_battle()
