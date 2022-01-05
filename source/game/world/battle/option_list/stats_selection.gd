extends OptionList

func _ready():
	add_targets()

func add_targets():
	for ch in battlers:
		add_item(ch.name)

func _on_OptionList_item_activated(index: int):
	._on_OptionList_item_activated(index)
	var battler = battlers[index]
	emit_signal("stats_decided", battler)
	option_ui.request_battle_action(character)
	queue_free()
