extends ItemList
class_name OptionList

signal action_decided(action)
signal target_decided(target)

func _ready():
	grab_focus()

func _on_OptionList_item_selected(index):
	pass # Replace with function body.
