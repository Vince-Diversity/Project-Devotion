extends OptionList

var targets: Array

func add_targets():
	for target in targets:
		add_item(target.name)

func _on_OptionList_item_selected(index):
	emit_signal("target_decided", targets[index])
