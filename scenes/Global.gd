class_name Global

enum OpCode {
	
	NEW_GAME,
	LOAD_GAME,
	SAVE_GAME,
	
	EXIT_GAME,
	TILE_QUERY,
	
	BUILD_ROAD,
	BUILD_RAIL,
	BUILD_WORLD_OBJECT,
	
	BUILD_COMPANY_HQ,
	
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
	
	OpCode.BUILD_COMPANY_HQ: {
		dimension = Vector2(2, 2),
		mode = SelectMode.FIXED,
		repeat = false,
		on_water = false,
		on_slope = false,
	},
	
	OpCode.CLEAR_LAND: {
		dimension = Vector2.ONE,
		mode = SelectMode.DRAG,
		repeat = true,
		on_water = true,
		on_slope = true,	
	}
	
}
