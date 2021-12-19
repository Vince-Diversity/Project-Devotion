extends GameWorld
class_name Overworld

onready var menu = $Menu
onready var party = $Party
onready var npcs = $NPCs

func _ready():
	init_party()

func _process(_delta):
	if Input.is_action_pressed("ui_menu"):
		menu.get_popup().popup()
	if Input.is_action_pressed("ui_accept"):
		start_battle(npcs.get_node("Miranda"))

func init_party():
	for ally in party_arr:
		party.add_child(ally)

func start_battle(npc: NPC):
	npc.confirm_battle()
