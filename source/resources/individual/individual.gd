extends Resource
class_name Individual

export var name: String
export var body: SpriteFrames
export var hair: SpriteFrames
export var accessories: SpriteFrames

func get_sprites():
	return [body, hair, accessories]
