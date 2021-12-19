extends Resource
class_name Individual

export var name: String
export var body: SpriteFrames
export var hair: SpriteFrames
export var accessories: SpriteFrames
export var aspect: Resource
export var lvl: int

func get_sprites():
	return [body, hair, accessories]
