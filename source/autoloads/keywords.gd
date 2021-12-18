extends Node

enum Aspect {SPACE, ENERGY, MATTER, TIME}

enum Anims {IDLE_DOWN, TENSE}

const aspect_descr = {
	Aspect.SPACE: "spatial",
	Aspect.ENERGY: "dynamical",
	Aspect.MATTER: "material",
	Aspect.TIME: "temporal",
}

const anim = {
	Anims.TENSE: "tense",
	Anims.IDLE_DOWN: "default",
}
