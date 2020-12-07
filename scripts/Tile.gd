extends Node2D
onready var background = $Background
onready var hoverSprite = $HoverSprite
onready var selectionSprite = $SelectionSprite

var posX
var posY
var isSelected = false

signal tileClicked

func _ready():
	pass # Replace with function body.

func selectTile():
	selectionSprite.visible = true
	isSelected = !isSelected

func unSelectTile():
	selectionSprite.visible = false
	isSelected = !isSelected

func _on_Area2D_mouse_entered():
	hoverSprite.visible = true

func _on_Area2D_mouse_exited():
	hoverSprite.visible = false

func _on_InnerArea2D_input_event(viewport, event, shape_idx):
	var clickEvent = event.is_pressed()
	if clickEvent:
		if isSelected:
			unSelectTile()
		else:
			selectTile()
		emit_signal("tileClicked", posX, posY)
