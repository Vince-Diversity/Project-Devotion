extends ItemList
class_name OptionList

# warning-ignore:unused_signal
signal action_decided(action)
# warning-ignore:unused_signal
signal target_decided(target)

var battle_ui

func _ready():
	grab_focus()

func init_battle_ui_connection():
	var err = connect("action_decided", battle_ui, "_on_OptionList_action_decided")
	if err != OK: print("Error %s connecting option list" % err)

# warning-ignore:unused_argument
func _on_OptionList_item_activated(index: int):
	queue_free()
