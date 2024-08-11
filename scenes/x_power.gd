extends Node2D


func despawn_x():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 3.0)
