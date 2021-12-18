extends Resource
class_name Battle

export var foe_1: Resource
export var foe_2: Resource
export var foe_3: Resource
export var foe_4: Resource
export var spectators := []

func get_opponents():
	var foes = [foe_1, foe_2, foe_3, foe_4]
	for i in foes.size():
		if foes[i] == null:
			foes.remove(i)
	return foes
