class_name  TileInfo

var geoType

static func getNeighbourTiles(x, y, matrix):
	var neighbours = []

	if (x % 2 == 0):
		neighbours.append(Vector2(x - 1, y - 1))
		neighbours.append(Vector2(x - 1,y))
		
		neighbours.append(Vector2(x + 1,y - 1))
		neighbours.append(Vector2(x + 1,y))
	else:
		neighbours.append(Vector2(x - 1, y))
		neighbours.append(Vector2(x - 1,y + 1))
		
		neighbours.append(Vector2(x + 1,y))
		neighbours.append(Vector2(x + 1,y + 1))
	
	neighbours.append(Vector2(x, y - 1))
	neighbours.append(Vector2(x, y + 1))

	return neighbours
