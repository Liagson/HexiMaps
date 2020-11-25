extends Node2D
onready var background = $Background

func _ready():
	pass # Replace with function body.

func _on_Area2D_mouse_entered():
	background.modulate = "3e5085"

func _on_Area2D_mouse_exited():
	background.modulate = "ffffff"
