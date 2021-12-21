extends ItemList

enum Options {ATTACK, ASPECT, WAIT}

const item_dict = {
	Options.ATTACK: "attack",
	Options.ASPECT: "aspect",
	Options.WAIT: "wait",
}
var item_names := ["", "", ""]

func _ready():
	init_item_list()
	init_items()

func init_item_list():
	var item_index
	for opt in Options:
		item_index = Options[opt]
		item_names[item_index] = item_dict[item_index]

func init_items():
	for n in item_names:
		add_item(n)
