extends Node2D

onready var geoMap = $GeoMap
onready var mapCreator = $MapCreator

func _ready():
	var geoTypeMatrix = mapCreator.getTileMatrix(15, 12)
	mapCreator.constructGeoMap(geoTypeMatrix, geoMap)
	geoMap.setSignalsForChildren()

