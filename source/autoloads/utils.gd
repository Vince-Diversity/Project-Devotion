extends Node

enum SaveKey {GAME}

func gen_save_key(node: Node) -> String:
	"""
	Every entry in the save dictionary needs a unique key.
	Use this generator for it.
	"""
	return "%s_%s" % [SaveKey.GAME, node.name]
