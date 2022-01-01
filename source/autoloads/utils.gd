extends Node

enum SaveKey {GAME}


func append_unique(arr, el, description: String) -> bool:
	if arr.has(el):
		print("Error: %s already exists in %s!" % [el, description])
		return false
	arr.append(el)
	return true

func array_max(arr: Array):
	var m = arr[0]
	for i in arr.size()-1:
		m = max(m, arr[i+1])
	return m

func Array(size: int) -> Array:
	var arr = []
	for _i in range(size):
		arr.append(0)
	return arr

func snap_to_compass(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO: return direction
	if direction in Kw.anim_map.keys(): return direction
	
	var snapped_angle = stepify(direction.angle(), PI / 2)
	var snapped_vector = Vector2.RIGHT.rotated(snapped_angle)
	if is_equal_approx(snapped_vector.x, 0): snapped_vector.x = 0
	if is_equal_approx(snapped_vector.y, 0): snapped_vector.y = 0
	return snapped_vector
