extends Resource
class_name Battle

export var foe_1: Resource
export var foe_2: Resource
export var foe_3: Resource
export var foe_4: Resource
export var spectators := []

func get_opponents():
	var all = [foe_1, foe_2, foe_3, foe_4]
	var foes = []
	for foe in all:
		if foe != null: foes.append(foe)
	return foes
