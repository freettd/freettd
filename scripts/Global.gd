class_name Global

enum OpCode {
	EXIT_GAME,
	TILE_QUERY,
	
	BUILD_ROAD,
	BUILD_RAIL,
	
	CLEAR_LAND,
	
}

enum SelectMode {
	
	# object placement
	FIXED,
	
	# land area selection
	DRAG,
	
	# rail
	LINE45,
	
	# road, canal
	LINE90,
	
}

const SelectorConfig: Dictionary = {
	
	OpCode.TILE_QUERY: {
		dimension = Vector2.ONE,
		mode = SelectMode.FIXED,
		repeat = true,
		on_water = true,
		on_slope = true,
	},
	
	OpCode.BUILD_ROAD: {
		dimension = Vector2.ONE,
		mode = SelectMode.LINE90,
		repeat = true,
		on_water = false,
		on_slope = true,
	},
	
	OpCode.BUILD_RAIL: {
		dimension = Vector2.ONE,
		mode = SelectMode.LINE45,
		repeat = true,
		on_water = false,
		on_slope = true,
	},
	
	OpCode.CLEAR_LAND: {
		dimension = Vector2.ONE,
		mode = SelectMode.DRAG,
		repeat = true,
		on_water = true,
		on_slope = true,	
	}
	
}
