extends YSort
class_name Party

func assign_members():
	for member in get_children():
		member.party = self

func set_state(st):
	for member in get_children():
		member.state = st

func set_cam_to(ally):
	ally.leader_cam.current = true

func get_state():
	return get_leader().state

func get_leader():
	var leader
	for member in get_children():
		if member.party_order == 0:
			leader = member
	return leader

func get_party_ordered() -> Array:
	var list = get_children()
	list.invert()
	return list
