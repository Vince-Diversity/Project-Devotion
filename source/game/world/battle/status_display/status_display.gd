extends VBoxContainer

onready var ch_status_scene = preload("res://source/game/world/battle/status_display/character_status.tscn")

func add_character(ch: Character):
	var ch_status = ch_status_scene.instance()
	var hp = ch.aspect.hp
	add_child(ch_status)
	ch_status.hp_max = hp
	ch_status.character_label.text = "%s[%s]" % [ch.name, ch.aspect.symbol]
	ch_status.hp_bar.set_max(hp)
	ch_status.hp_bar.set_value(hp)
	ch_status.set_hp_text(hp)
	return ch_status
