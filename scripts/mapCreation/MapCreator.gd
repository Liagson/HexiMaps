extends Node

const Tile = preload("res://scenes/Tile.tscn")
const TileGeoInfo = preload("res://scripts/mapCreation/TileGeoInfo.gd")
const TileInfo = preload("res://scripts/mapCreation/GameTileInfo.gd")

onready var heightNoise = $HeightNoise
onready var forestNoise = $ForestNoise

var tileSize: Vector2

func _ready():
	tileSize = Tile.instance().get_node("Background").texture.get_size()

func constructGeoMap(geoTypeMatrix, geoMap):
	geoMap.matrix = getEmptyGeoMapMatrix(geoTypeMatrix)
	for x in range(2, geoTypeMatrix.size() - 2):
		for y in range(2, geoTypeMatrix[0].size() - 2):
			var tile = Tile.instance()
			tile.geoType = geoTypeMatrix[x][y].geoType
			setTileGeoTexture(tile, getTileGeoTexture(tile.geoType))
			tile.position = getTilePosition(x, y)			
			tile.posX = x
			tile.posY = y
			
			geoMap.matrix[x][y] = tile
			geoMap.add_child(tile)

func getEmptyGeoMapMatrix(geoTypeMatrix):
	var geoMapMatrix = []
	for x in range(0, geoTypeMatrix.size()):
		geoMapMatrix.append([])
		for y in range(0, geoTypeMatrix[0].size()):
			geoMapMatrix[x].append([])
			geoMapMatrix[x][y] = null # borders will go empty
	return geoMapMatrix

func getTileMatrix(width, height):
	var matrix = []
	for x in range(width + 4):
		matrix.append([])
		for y in range(height + 4):
			matrix[x].append([])
			
			# we leave an empty border
			if x > 1 and x < (width + 2) and y > 1 and y < (height + 2):
				var heightNoiseValue = heightNoise.texture.noise.\
				get_noise_2d(x * tileSize.x, y * tileSize.y)
				var tileInfo = TileInfo.new()
				tileInfo.geoType = getTileGeoTipe(heightNoiseValue)
				setForestTile(x, y, tileInfo)
				matrix[x][y] = tileInfo

	setTowns(matrix)
	
	return matrix

func setForestTile(x, y, currentTile):
	var forestNoiseValue = forestNoise.texture.noise.\
	get_noise_2d(x * tileSize[0], y * tileSize[1])

	# TODO: this should be defined somewhere else
	if forestNoiseValue > 0.1:
		if currentTile.geoType == TileGeoInfo.TileTipe.field_green:
			currentTile.geoType = TileGeoInfo.TileTipe.forest_standard

func setSuburbs(x, y, matrix):
	var neighbourTiles = TileInfo.getNeighbourTiles(x, y, matrix)
	for tile in neighbourTiles:
		var neighbourTile = matrix[tile.x][tile.y]
		if neighbourTile \
		  and TileGeoInfo.isArableLand(neighbourTile.geoType):
			var diceResult = randi()%20+1
			if diceResult > 15:
				matrix[tile.x][tile.y].geoType = TileGeoInfo.TileTipe.crop_field
			elif diceResult > 8:
				 matrix[tile.x][tile.y].geoType = TileGeoInfo.TileTipe.corn_field
			else:
				matrix[tile.x][tile.y].geoType = TileGeoInfo.TileTipe.village

func setTowns(matrix):
	for x in range(2, matrix.size() - 2):
		for y in range(2, matrix[0].size() - 2):
			if TileGeoInfo.isTileBuildable(matrix[x][y].geoType):
				var diceResult = randi()%20+1
				# TODO: this should be defined somewhere else
				if diceResult == 20:
					matrix[x][y].geoType = TileGeoInfo.TileTipe.town
					setSuburbs(x, y, matrix)

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

func getTilePosition(relativeX, relativeY):
	var tileWidth = tileSize[0]
	var tileHeight = tileSize[1]
	var verticalOffset = 0 if relativeX % 2 == 0 else (tileHeight / 2)
		
	return Vector2(relativeX * floor(tileWidth * 0.75),\
	 verticalOffset + (relativeY * tileHeight))
