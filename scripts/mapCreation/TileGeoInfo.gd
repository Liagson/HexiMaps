enum TileTipe {
	deepSea,
	shallowSea,
	field_green,
	hills_green,
	mountains,
	forest_standard,
	town
}

const tileTextures = {
	TileTipe.deepSea : "res://tiles/pngs/deep_sea.png",
	TileTipe.shallowSea : "res://tiles/pngs/shallow_sea.png",
	TileTipe.field_green : "res://tiles/pngs/green_field.png",
	TileTipe.hills_green : "res://tiles/pngs/hills_(green).png",
	TileTipe.mountains : "res://tiles/pngs/mountains.png",
	TileTipe.forest_standard : "res://tiles/pngs/forest_(standard).png",
	TileTipe.town : "res://tiles/pngs/town.png"
}

static func isTileBuildable(geotipe):
	if geotipe == TileTipe.deepSea:
		return false
	if geotipe == TileTipe.shallowSea:
		return false
	if geotipe == TileTipe.mountains:
		return false
	else:
		return true
