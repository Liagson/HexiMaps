extends Node

const Tile = preload("res://Tile.tscn")
const TileGeoInfo = preload("res://scripts/TileGeoInfo.gd")
onready var heightNoise = $HeightNoise

# Called when the node enters the scene tree for the first time.
func _ready():
	var noiseValue = null
	var tile = null
	var tileGeoTipe = null
	var tileSize = Tile.instance().get_node("Background").texture.get_size()
	var geoMap = get_node("../GeoMap")
	
	for y in range(12):
		for x in range(15):
			var heightNoiseValue = heightNoise.texture.noise.\
			get_noise_2d(x * tileSize[0], y * tileSize[1])
			tile = Tile.instance()
			tileGeoTipe = getTileGeoTipe(heightNoiseValue)
			tile.get_node("Background").texture = getTileGeoTexture(tileGeoTipe)
			tile.position = getTilePosition(x, y, tileSize)
			geoMap.add_child(tile)

func getTileGeoTipe(heightValue):
	if heightValue <= -0.75:
		return TileGeoInfo.TileTipe.deepSea
	elif heightValue > -0.75 and heightValue <= -0.25:
		return TileGeoInfo.TileTipe.shallowSea
	elif heightValue > -0.25 and heightValue <= 0.25:
		return TileGeoInfo.TileTipe.field_green
	elif heightValue > 0.25 and heightValue <= 0.5:
		return TileGeoInfo.TileTipe.hills_green
	else:
		return TileGeoInfo.TileTipe.mountains

func getTileGeoTexture(geoTipe):
	return load(TileGeoInfo.tileTextures[geoTipe])

func getTilePosition(relativeX, relativeY, tileSize):
	var tileWidth = tileSize[0]
	var tileHeight = tileSize[1]
	var verticalOffset = 0 if relativeX % 2 == 0 else (tileHeight / 2)
		
	return Vector2(relativeX * floor(tileWidth * 0.75),\
	 verticalOffset + (relativeY * tileHeight))
