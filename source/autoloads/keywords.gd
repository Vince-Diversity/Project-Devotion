extends Node

enum Aspects {SPACE, ENERGY, MATTER, TIME}

enum Anims {IDLE_DOWN, TENSE, DOWN, LEFT, UP, RIGHT}

enum Stats {HP, POWER, SPEED}

enum OwStates {ROAMING, INTERACTING, BATTLING}

const aspect_descr = {
	Aspects.SPACE: "spatial",
	Aspects.ENERGY: "dynamical",
	Aspects.MATTER: "material",
	Aspects.TIME: "temporal",
}

const anim = {
	Anims.IDLE_DOWN: "default",
	Anims.TENSE: "tense",
	Anims.DOWN: "down",
	Anims.LEFT: "left",
	Anims.UP: "up",
	Anims.RIGHT: "right",
}

const anim_map = {
	Vector2.ZERO: Anims.IDLE_DOWN,
	Vector2.DOWN: Anims.DOWN,
	Vector2.LEFT: Anims.LEFT, 
	Vector2.UP: Anims.UP,
	Vector2.RIGHT: Anims.RIGHT,
}
