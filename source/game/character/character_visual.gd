extends Node2D

func set_animation(anim_name):
	for sprite in get_sprites():
		sprite.set_animation(anim_name)

func animate_idle():
	for sprite in get_sprites():
		sprite.stop()
		sprite.set_frame(0)

func animate_movement(anim_name):
	for sprite in get_sprites():
		sprite.play(anim_name)

func reset_sprite():
	for sprite in get_sprites():
		sprite.set_flip_h(false)

func flip_sprite():
	for sprite in get_sprites():
		sprite.set_flip_h(true)

func get_sprites():
	return get_children()
