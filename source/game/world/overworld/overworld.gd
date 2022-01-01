extends GameWorld
class_name Overworld

var can_accept := true
onready var menu = $Menu
onready var party = $Characters/Party
onready var npcs = $Characters/NPCs/PracticeParty

func _ready():
	init_party()

func _process(_delta):
	if Input.is_action_pressed("ui_menu"):
		menu.get_popup().popup()
	if Input.is_action_just_pressed("ui_accept") and can_accept:
		can_accept = false
		var ally_leader = party.get_leader()
		var ally_leader_area = ally_leader.interaction_area
		var areas = ally_leader_area.get_overlapping_areas()
		for area in areas:
			if area is InteractionArea:
				for ally in ally_leader.get_party_ordered():
					ally.prepare_talking()
				var npc = areas[0].character
				var d = Dialogic.start(npc.interaction_dialog)
				add_child(d)
				var keep_talk = true
				while keep_talk:
					var response = yield(d, "dialogic_signal")
					match response:
						"battle":
							npc.confirm_battle()
						"done":
							keep_talk = false
							for ally in ally_leader.get_party_ordered():
								ally.prepare_roaming()
							yield(get_tree().create_timer(0.2), "timeout")
							can_accept = true

func init_party():
	for ally in party_arr:
		party.add_child(ally)
