extends Node

enum Aspect {SPACE, ENERGY, MATTER, TIME}

enum Anims {IDLE_DOWN, TENSE, DOWN, LEFT, UP, RIGHT}

enum Stats {HP, POWER, SPEED}

const aspect_descr = {
	Aspect.SPACE: "spatial",
	Aspect.ENERGY: "dynamical",
	Aspect.MATTER: "material",
	Aspect.TIME: "temporal",
}

const anim = {
	Anims.IDLE_DOWN: "default",
	Anims.TENSE: "tense",
	Anims.DOWN: "down",
	Anims.LEFT: "left",
	Anims.UP: "up",
}

var anim_map = {
	Vector2.DOWN: Anims.DOWN,
	Vector2.LEFT: Anims.LEFT, 
	Vector2.UP: Anims.UP,
	Vector2.RIGHT: Anims.RIGHT,
}
