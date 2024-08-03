extends Camera2D


var shake_strength : float = 0.0
var shake_fade : float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()

func camera_shake(strength, fade):
	shake_strength = strength
	
func random_offset():
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
