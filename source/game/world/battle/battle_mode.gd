extends GameWorld

onready var spectators = $Spectators
onready var opponents = $Opponents
onready var allies = $Allies

func commence_battle():
	ready_characters()

func ready_characters():
	_ready_character_helper(opponents, Kw.anim[Kw.Anims.TENSE])
	_ready_character_helper(allies, Kw.anim[Kw.Anims.TENSE])
	_ready_character_helper(spectators, Kw.anim[Kw.Anims.IDLE_DOWN])

func _ready_character_helper(role, anim):
	for i_pos in role.get_children():
		for i in i_pos.get_children():
			for sprite in i.get_sprites():
				sprite.set_animation(anim)
