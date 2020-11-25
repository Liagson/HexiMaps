extends Node

const Tile = preload("res://Tile.tscn")
onready var noise = $Noise

# Called when the node enters the scene tree for the first time.
func _ready():
	var noiseValue = null
	var tile = null
	var tileSize = Tile.instance().get_node("Background").texture.get_size()
	var geoMap = get_node("../GeoMap")

	for y in range(12):
		for x in range(15):
			noiseValue = noise.texture.noise.\
			get_noise_2d(x * tileSize[0], y * tileSize[1])
			tile = Tile.instance()
			tile.get_node("Background").texture = getTileTexture(noiseValue)
			tile.position = getTilePosition(x, y, tileSize)
			geoMap.add_child(tile)
			

func getTileTexture(heightValue):
	# todo: el parametro de entrada deberia de ser un enum
	# mete la logica de decidir en otro metodo. maybe
	if heightValue <= -0.75:
		return load("res://tiles/pngs/deep_sea.png")
	elif heightValue > -0.75 and heightValue <= -0.25:
		return load("res://tiles/pngs/shallow_sea.png")
	elif heightValue > -0.25 and heightValue <= 0.25:
		return load("res://tiles/pngs/green_field.png")
	elif heightValue > 0.25 and heightValue <= 0.5:
		return load("res://tiles/pngs/hills_(green).png")
	else:
		return load("res://tiles/pngs/mountains.png")

func getTilePosition(relativeX, relativeY, tileSize):
	var tileWidth = tileSize[0]
	var tileHeight = tileSize[1]
	var verticalOffset = 0 if relativeX % 2 == 0 else (tileHeight / 2)
		
	return Vector2(relativeX * floor(tileWidth * 0.75),\
	 verticalOffset + (relativeY * tileHeight))
