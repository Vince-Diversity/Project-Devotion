extends OptionList

var targets: Array

func _ready():
	add_targets()

func add_targets():
	for target in targets:
		add_item(target.name)

func _on_OptionList_item_activated(index: int):
	._on_OptionList_item_activated(index)
	var size = targets.size()
	if index < size:
		emit_signal("target_decided", targets[index])
	queue_free()
