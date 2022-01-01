extends YSort
class_name Party

func get_leader():
	var leader
	for member in get_children():
		if member.party_order == 0:
			leader = member
	return leader
