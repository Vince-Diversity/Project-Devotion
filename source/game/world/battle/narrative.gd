extends RichTextLabel

func tell(content):
	text = content

func display_stats(character, state):
	var derived_stats = DerivedStats.new(state)
	var content = "%s (%s[%s]):\n" % [character.name, state.name, state.symbol]
	content += "hp: %d, pwr: %d,\n" % [state.hp, state.pwr]
	content += "dodge rate: %0.2f,\ncrit rate: %0.2f." \
	% [derived_stats.get_dodge_rate(), derived_stats.get_crit_rate()]
	text = content

func _on_Aspect_stat_changed(stat, val):
	match stat:
		Kw.Stats.HP:
			tell("Dealt %s hp!" % [val])
