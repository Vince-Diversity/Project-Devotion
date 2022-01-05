extends Object
class_name HitShare

var share

func _init(user_state, target_state, target_aspect):
	var user_hhp = user_state.hp / 2
	var target_lost_hp = target_aspect.hp - target_state.hp
	share =  min(target_lost_hp, user_hhp)
