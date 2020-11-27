extends Node

const Tile = preload("res://scenes/Tile.tscn")
const TileGeoInfo = preload("res://scripts/mapCreation/TileGeoInfo.gd")
const TileInfo = preload("res://scripts/mapCreation/GameTileInfo.gd")

onready var heightNoise = $HeightNoise
onready var forestNoise = $ForestNoise

func _ready():
	pass

func constructGeoMap(geoMap):
	var matrix = geoMap.matrix
	var tileSize = Tile.instance().get_node("Background").texture.get_size()
	
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			var tile = Tile.instance()
			setTileGeoTexture(tile, getTileGeoTexture(matrix[x][y].geoType))
			tile.position = getTilePosition(x, y, tileSize)
			geoMap.add_child(tile)
	

func getTileMatrix(width, height):
	var matrix = []
	var tileSize = Tile.instance().get_node("Background").texture.get_size()
	for x in range(width):
		matrix.append([])
		for y in range(height):
			matrix[x].append([])
			var heightNoiseValue = heightNoise.texture.noise.\
			get_noise_2d(x * tileSize[0], y * tileSize[1])
			var tileInfo = TileInfo.new()
			tileInfo.geoType = getTileGeoTipe(heightNoiseValue)
			matrix[x][y] = tileInfo

	setForest(matrix)
	
	return matrix

func setForest(matrix):
	var tileSize = Tile.instance().get_node("Background").texture.get_size()
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			var forestNoiseValue = forestNoise.texture.noise.\
			get_noise_2d(x * tileSize[0], y * tileSize[1])
			
			if forestNoiseValue > 0.1:
				if matrix[x][y].geoType == TileGeoInfo.TileTipe.field_green:
					matrix[x][y].geoType = TileGeoInfo.TileTipe.forest_standard
				

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

func setTileGeoTexture(tile, geoTexture):
	tile.get_node("Background").texture = geoTexture

func getTilePosition(relativeX, relativeY, tileSize):
	var tileWidth = tileSize[0]
	var tileHeight = tileSize[1]
	var verticalOffset = 0 if relativeX % 2 == 0 else (tileHeight / 2)
		
	return Vector2(relativeX * floor(tileWidth * 0.75),\
	 verticalOffset + (relativeY * tileHeight))
