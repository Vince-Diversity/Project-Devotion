extends Node2D

func set_animation(true_anim_name):
	var anim_name = parse_anim_name(true_anim_name)
	for sprite in get_sprites():
		sprite.set_animation(anim_name)

func parse_anim_name(true_anim_name: String) -> String:
	var anim_name
	if true_anim_name == Kw.anim[Kw.Anims.RIGHT]:
		anim_name = Kw.anim[Kw.Anims.LEFT]
		flip_sprite()
	else:
		reset_sprite()
		anim_name = true_anim_name
	return anim_name

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

func is_flipped() -> bool:
	if get_sprites()[0].is_flipped_h():
		return true
	return false
