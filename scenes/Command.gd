class_name Command

const GROUP_TREE: String = "GROUP_TREE"

enum Action {
	
	START_APP,
	
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
	
	BUILD_ROAD_DEPOT,
	BUILD_TRUCK_TERMINAL,
	BUILD_PAX_TERMINAL,
	BUILD_TRUCK_STOP,
	BUILD_PAX_STOP,
	
	BUILD_COMPANY_HQ,
	
	BUY_VEHICLE,
	SELL_VEHICLE,
	
	CLEAR_LAND,
	PLANT_TREE,
	
	CONFIG_TRANSPARENT_TREES
	
}

const ConfigCommands: Array = [ Action.CONFIG_TRANSPARENT_TREES ]

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
	
	Action.TILE_QUERY: {
		dimension = Vector2.ONE,
		mode = SelectMode.FIXED,
		repeat = true,
		on_water = true,
		on_slope = true,
	},
	
	Action.BUILD_ROAD: {
		dimension = Vector2.ONE,
		mode = SelectMode.LINE90,
		repeat = true,
		on_water = false,
		on_slope = true,
	},
	
	
	Action.BUILD_ROAD_DEPOT: {
		dimension = Vector2.ONE,
		mode = SelectMode.LINE90,
		repeat = true,
		on_water = false,
		on_slope = false,
	},
	
	Action.BUILD_RAIL: {
		dimension = Vector2.ONE,
		mode = SelectMode.LINE45,
		repeat = true,
		on_water = false,
		on_slope = true,
	},
	
	Action.BUILD_COMPANY_HQ: {
		dimension = Vector2(2, 2),
		mode = SelectMode.FIXED,
		repeat = false,
		on_water = false,
		on_slope = false,
	},
	
	Action.CLEAR_LAND: {
		dimension = Vector2.ONE,
		mode = SelectMode.DRAG,
		repeat = true,
		on_water = true,
		on_slope = true,	
	},
	
	Action.PLANT_TREE: {
		dimension = Vector2.ONE,
		mode = SelectMode.DRAG,
		repeat = true,
		on_water = false,
		on_slope = true,	
	}	
	
}
