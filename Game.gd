extends Node2D

onready var geoMap = $GeoMap
onready var mapCreator = $MapCreator

func _ready():
	geoMap.matrix = mapCreator.getTileMatrix(15, 12)
	mapCreator.constructGeoMap(geoMap.matrix, geoMap.get_path()) 
