extends Node

enum SaveKey {GAME}

func gen_save_key(node: Node) -> String:
	"""
	Every entry in the save dictionary needs a unique key.
	Use this generator for some of them.
	"""
	return "%s_%s" % [SaveKey.GAME, node.name]

func append_unique(arr, el, description: String) -> bool:
	if arr.has(el):
		print("Error: %s already exists in %s!" % [el, description])
		return false
	arr.append(el)
	return true