extends HBoxContainer

var hp_max
onready var character_label = $CharacterLabel
onready var hp_bar = $HPBar
onready var hp_label = $HPLabel

func _on_Aspect_stat_changed(stat, new_val):
	match stat:
		Kw.Stats.HP:
			hp_bar.set_value(new_val)
			set_hp_text(new_val)

func set_hp_text(hp):
	hp_label.text = "%d/%d" % [hp, hp_max]
