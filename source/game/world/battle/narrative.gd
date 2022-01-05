extends RichTextLabel

func tell(content):
	text = content

func display_stats(character, state):
	var content = "%s stats:\n" % character.name
	content += "lvl: %d\n" % [character.lvl]
	content += "hp: %d, pwr: %d, spd: %d\n" % [state.hp, state.pwr, state.spd]
	text = content

func _on_Aspect_stat_changed(stat, val):
	match stat:
		Kw.Stats.HP:
			tell("Dealt %s hp!" % [val])
