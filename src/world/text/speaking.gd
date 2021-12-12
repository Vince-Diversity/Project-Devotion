extends RichTextLabel

onready var speech_player:AudioStreamPlayer = $SpeechPlayer
var is_speaking:bool
var numofchars:int
var chunk_size:float
var speed := 32.0
var accumulator := 0.0

func _ready():
	percent_visible = 0.0
	speak()

func _process(delta):
	if is_speaking:
		accumulator += delta * chunk_size
		if accumulator > 1.0/numofchars:
			speech_player.play()
			percent_visible += accumulator
			accumulator = 0.0
		if percent_visible >= 1.0:
			is_speaking = false

func speak():
	numofchars = text.length()
	if numofchars != 0:
		print(text)
		chunk_size = (1.0/numofchars)*speed
		is_speaking = true
