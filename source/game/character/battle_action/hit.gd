extends Object
class_name Hit

var damage := 0

func _init(attack_damage: int, additional_damage: int = 0):
	damage = attack_damage + additional_damage
