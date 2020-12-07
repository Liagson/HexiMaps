extends Node2D
onready var background = $Background
onready var selectionSprite = $SelectionSprite

func _ready():
	pass # Replace with function body.

func _on_Area2D_mouse_entered():
	selectionSprite.visible = true

func _on_Area2D_mouse_exited():
	selectionSprite.visible = false
