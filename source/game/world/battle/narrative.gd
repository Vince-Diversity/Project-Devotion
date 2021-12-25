extends RichTextLabel

func tell(content):
	text = content

func _on_Aspect_stat_changed(stat, val):
	match stat:
		Kw.Stats.HP:
			tell("Dealt %s hp!" % [val])
