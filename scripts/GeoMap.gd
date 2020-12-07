extends Node

const TileInfo = preload("res://scripts/mapCreation/GameTileInfo.gd")
var matrix

func _ready():
	pass

func setSignalsForChildren():
	# TODO: maybe loop the instance matrix?
	var children = get_children()
	for child in children:
		get_node(child.get_path()).connect("tileClicked", self, "tileClicked")

func tileClicked(x, y):
	var neighbours = TileInfo.getNeighbourTiles(x, y, matrix)
	for neighbour in neighbours:
		var interactedTile = matrix[neighbour.x][neighbour.y]
		if interactedTile != null: # We skip the borders
			if interactedTile.isSelected:
				interactedTile.unSelectTile()
			else:
				interactedTile.selectTile()
