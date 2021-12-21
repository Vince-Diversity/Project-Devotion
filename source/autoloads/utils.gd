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
