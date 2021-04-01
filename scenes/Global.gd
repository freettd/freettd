class_name Global

const GROUP_TREE: String = "GROUP_TREE"

enum OpCode {
	
	NEW_GAME,
	NEW_SCENARIO,
	
	LOAD_GAME,
	SAVE_GAME,
	
	EXIT_APP,
	EXIT_GAME,
	
	
	TILE_QUERY,
	
	BUILD_ROAD,
	BUILD_RAIL,
	BUILD_WORLD_OBJECT,
	
	BUILD_COMPANY_HQ,
	
	CLEAR_LAND,
	PLANT_TREE,
	
	TERRAFORM_UP,
	TERRAFORM_DOWN,
	TERRAFORM_LEVEL
	
	CONFIG_TRANSPARENT_TREES
	
}

const ConfigCommands: Array = [ OpCode.CONFIG_TRANSPARENT_TREES ]

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

const SIMPLE_DRAG = {
	dimension = Vector2.ONE,
	mode = SelectMode.DRAG,
	repeat = true,
	on_water = true,
	on_slope = true,	
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
	
	OpCode.PLANT_TREE: {
		dimension = Vector2.ONE,
		mode = SelectMode.DRAG,
		repeat = true,
		on_water = false,
		on_slope = true,	
	},
	
	OpCode.CLEAR_LAND: SIMPLE_DRAG,
	OpCode.TERRAFORM_UP: SIMPLE_DRAG,
	OpCode.TERRAFORM_DOWN: SIMPLE_DRAG,
	OpCode.TERRAFORM_LEVEL: SIMPLE_DRAG	
	
}
